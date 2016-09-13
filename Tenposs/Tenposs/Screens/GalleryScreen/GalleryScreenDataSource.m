//
//  GalleryScreenDataSource.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/21/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "GalleryScreenDataSource.h"
#import "TenpossCommunicator.h"
#import "MockupData.h"
#import "PhotoCategoryCommunicator.h"
#import "AppConfiguration.h"
#import "Utils.h"
#import "Const.h"

@interface GalleryScreenDataSource() <TenpossCommunicatorDelegate, SimpleDataSourceDelegate>
@property (strong, nonatomic) NSMutableArray<GalleryScreenDetailDataSource *> *detailDataSourceList;
@property (assign, nonatomic)BOOL shouldShowLatest;
@property (assign, nonatomic)NSInteger currentDetailDataSourceIndex;
@property (strong, nonatomic)GalleryDataCompleteHandler currentCompleteHandler;

@end

@implementation GalleryScreenDataSource


- (instancetype)initAndShouldShowLatest:(BOOL)shouldShowLatest{
    self = [super init];
    if (self) {
        self.shouldShowLatest = shouldShowLatest;
        self.detailDataSourceList = (NSMutableArray<GalleryScreenDetailDataSource *> *)[[NSMutableArray alloc]init];
        self.currentDetailDataSourceIndex = -1;
    }
    return self;
}

#pragma mark - Public methods
- (void)fetchDataWithCompleteHandler:(GalleryDataCompleteHandler)handler{
    self.currentCompleteHandler = handler;
    if ([self.detailDataSourceList count] <= 0) {
        [self loadPhotoCategoryList];
    }else{
        if (self.currentDetailDataSourceIndex >= 0 && self.currentDetailDataSourceIndex < [self.detailDataSourceList count]) {
            [self updateCurrentDetailDataSource:self.detailDataSourceList[self.currentDetailDataSourceIndex]];
        }else{
            if (self.shouldShowLatest) {
                NSInteger lastSourceIndex = [self.detailDataSourceList count] -1;
                [self updateCurrentDetailDataSource:self.detailDataSourceList[lastSourceIndex]];
                self.shouldShowLatest = NO;
            }
        }
    }
}

- (void)changeToNextDetailDataSourceWithCompleteHandler:(GalleryDataCompleteHandler)handler{
    if (![self detailDataSourceHasNext:self.activeDetailDataSource]) {
        NSError *error = [NSError errorWithDomain:@"" code:ERROR_DETAIL_DATASOURCE_IS_LAST userInfo:nil];
        handler(error, nil, NO,YES);
        return;
    }
    NSInteger indexToChangeTo = [self.detailDataSourceList indexOfObject:self.activeDetailDataSource] + 1;
    GalleryScreenDetailDataSource *sourceToChangeTo = self.detailDataSourceList[indexToChangeTo];
    if (sourceToChangeTo.mainData.category_id != self.activeDetailDataSource.mainData.category_id) {
        self.currentCompleteHandler = handler;
        [self updateCurrentDetailDataSource:sourceToChangeTo];
    }else{
        NSError *error = [NSError errorWithDomain:@"" code:ERROR_DETAIL_DATASOURCE_IS_DUBLICATED userInfo:nil];
        handler(error, nil, [self detailDataSourceHasNext:self.activeDetailDataSource],[self detailDataSourceHasPrevious:self.activeDetailDataSource]);
    }
}

- (void)changeToPreviousDetailDataSourceWithCompleteHandler:(GalleryDataCompleteHandler)handler{
    if (![self detailDataSourceHasPrevious:self.activeDetailDataSource]) {
        NSError *error = [NSError errorWithDomain:@"" code:ERROR_DETAIL_DATASOURCE_IS_FIRST userInfo:nil];
        handler(error, nil, YES,NO);
        return;
    }
    NSInteger indexToChangeTo = [self.detailDataSourceList indexOfObject:self.activeDetailDataSource] -1;
    GalleryScreenDetailDataSource *sourceToChangeTo = self.detailDataSourceList[indexToChangeTo];
    if (sourceToChangeTo.mainData.category_id != self.activeDetailDataSource.mainData.category_id) {
        self.currentCompleteHandler = handler;
        [self updateCurrentDetailDataSource:sourceToChangeTo];
    }else{
        NSError *error = [NSError errorWithDomain:@"" code:ERROR_DETAIL_DATASOURCE_IS_DUBLICATED userInfo:nil];
        handler(error, nil, [self detailDataSourceHasNext:self.activeDetailDataSource],[self detailDataSourceHasPrevious:self.activeDetailDataSource]);
    }
}

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.activeDetailDataSource itemAtIndexPath:indexPath];
}

- (void)loadMoreDataWithCompleteHandler:(GalleryDataCompleteHandler)handler{
    
}

#pragma mark - Communicator
-(void)loadPhotoCategoryList{
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    NSString * store_id = [appConfig getStoreId];
    
    PhotoCategoryCommunicator *request = [PhotoCategoryCommunicator new];
    Bundle *params = [Bundle new];
    [params put:KeyAPI_APP_ID value:APP_ID];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    [params put:KeyAPI_TIME value:currentTime];
    NSArray *strings = [NSArray arrayWithObjects:APP_ID,currentTime,store_id,APP_SECRET,nil];
    [params put:KeyAPI_SIG value:[Utils getSigWithStrings:strings]];
    [params put:KeyAPI_STORE_ID value:store_id];
    [request execute:params withDelegate:self];
}
#pragma mark - Helper Methods

- (void)updateCurrentDetailDataSource:(GalleryScreenDetailDataSource *)detail{
    self.activeDetailDataSource = detail;
    [self.activeDetailDataSource registerClassForCollectionView:self.collectionView];
    self.currentDetailDataSourceIndex = [self.detailDataSourceList indexOfObject:detail];
    [self.activeDetailDataSource loadData];
}

- (BOOL)detailDataSourceHasNext:(GalleryScreenDetailDataSource *)dataSource {
    NSInteger detailDataSourceCount = [self.detailDataSourceList count];
    if ((self.detailDataSourceList[detailDataSourceCount -1]).mainData.category_id == dataSource.mainData.category_id && [self.detailDataSourceList count] > 1) {
        return NO;
    }
    return YES;
}

- (BOOL)detailDataSourceHasPrevious:(GalleryScreenDetailDataSource *)dataSource{
    if ((self.detailDataSourceList[0]).mainData.category_id != dataSource.mainData.category_id && [self.detailDataSourceList count] > 1) {
        return NO;
    }
    return YES;
}

#pragma mark - TenpossCommunicatorDelegate

- (void)cancelAllRequest{}

- (void)begin:(TenpossCommunicator *)request data:(Bundle *)responseParams{}

- (void)completed:(TenpossCommunicator *)request data:(Bundle *)responseParams{
    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
    NSError *error = nil;
    if (errorCode != ERROR_OK) {
        NSString *errorDomain = [CommunicatorConst getErrorMessage:errorCode];
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
    }else{
        PhotoCategoryResponse *data = (PhotoCategoryResponse *)[responseParams get:KeyResponseObject];
        if (data.items && [data.items count] > 0) {
            for (PhotoCategory *cate in data.items) {
                GalleryScreenDetailDataSource *detailDataSource = [[GalleryScreenDetailDataSource alloc]initWithDelegate:self andPhotoCategory:cate];
                [self.detailDataSourceList addObject:detailDataSource];
            }
            if (self.shouldShowLatest) {
                [self updateCurrentDetailDataSource:[self.detailDataSourceList objectAtIndex:[self.detailDataSourceList count] -1]];
                self.shouldShowLatest = NO;
            }
            return;
        }else{
            error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_DATASOURCE_NO_CONTENT] code:ERROR_DATASOURCE_NO_CONTENT userInfo:nil];
        }
    }
    if (self.currentCompleteHandler) {
        self.currentCompleteHandler(error, @"", NO, NO);
        self.currentCompleteHandler = nil;
    }
}

#pragma mark - SimpleDataSourceDelegate
- (void)dataLoaded:(SimpleDataSource *)executor withError:(NSError *)error{
    GalleryScreenDetailDataSource *dataSource = (GalleryScreenDetailDataSource *)executor;
    if (!dataSource) {
        //TODO: handle nil detailDataSource
    }
    NSString *detailDataSourceTitle = dataSource.mainData.name;
    if (self.currentCompleteHandler) {
        if (error.code == ERROR_CONTENT_FULLY_LOADED) {
            self.currentCompleteHandler(nil, detailDataSourceTitle, [self detailDataSourceHasNext:dataSource], [self detailDataSourceHasPrevious:dataSource]);
            self.currentCompleteHandler = nil;
        }else{
            self.currentCompleteHandler(error, detailDataSourceTitle, [self detailDataSourceHasNext:dataSource], [self detailDataSourceHasPrevious:dataSource]);
            self.currentCompleteHandler = nil;
        }
    }
}

- (void)needRefreshItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)needRefreshSectionAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
