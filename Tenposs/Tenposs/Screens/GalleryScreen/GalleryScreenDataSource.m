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
        NSError *error = [NSError errorWithDomain:GalleryScreenError_isLast code:-9900 userInfo:nil];
        handler(error, nil, NO,YES);
        return;
    }
    NSInteger indexToChangeTo = [self.detailDataSourceList indexOfObject:self.activeDetailDataSource] + 1;
    GalleryScreenDetailDataSource *sourceToChangeTo = self.detailDataSourceList[indexToChangeTo];
    if (sourceToChangeTo.mainData.category_id != self.activeDetailDataSource.mainData.category_id) {
        self.currentCompleteHandler = handler;
        [self updateCurrentDetailDataSource:sourceToChangeTo];
    }else{
        NSError *error = [NSError errorWithDomain:GalleryScreenError_duplicate code:-9902 userInfo:nil];
        handler(error, nil, [self detailDataSourceHasNext:self.activeDetailDataSource],[self detailDataSourceHasPrevious:self.activeDetailDataSource]);
    }
}

- (void)changeToPreviousDetailDataSourceWithCompleteHandler:(GalleryDataCompleteHandler)handler{
    if (![self detailDataSourceHasPrevious:self.activeDetailDataSource]) {
        NSError *error = [NSError errorWithDomain:GalleryScreenError_isFirst code:-9901 userInfo:nil];
        handler(error, nil, YES,NO);
        return;
    }
    NSInteger indexToChangeTo = [self.detailDataSourceList indexOfObject:self.activeDetailDataSource] -1;
    GalleryScreenDetailDataSource *sourceToChangeTo = self.detailDataSourceList[indexToChangeTo];
    if (sourceToChangeTo.mainData.category_id != self.activeDetailDataSource.mainData.category_id) {
        self.currentCompleteHandler = handler;
        [self updateCurrentDetailDataSource:sourceToChangeTo];
    }else{
        NSError *error = [NSError errorWithDomain:GalleryScreenError_duplicate code:-9902 userInfo:nil];
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
    NSData *data = [MockupData fetchDataWithResourceName:@"photo_category"];
    NSError *error = nil;
    PhotoCategoryListModel *cateList = [[PhotoCategoryListModel alloc]initWithData:data error:&error];
    
    //TODO: Need mockup data
    if (!error && cateList && [cateList.items count] > 0) {
        for (PhotoCategory *category in cateList.items) {
            GalleryScreenDetailDataSource *detailDataSource = [[GalleryScreenDetailDataSource alloc]initWithDelegate:self andPhotoCategory:category];
            [self.detailDataSourceList addObject:detailDataSource];
        }
        if (self.shouldShowLatest) {
            NSInteger lastSourceIndex = [self.detailDataSourceList count] -1;
            [self updateCurrentDetailDataSource:self.detailDataSourceList[lastSourceIndex]];
            self.shouldShowLatest = NO;
        }else{
            NSInteger rand = arc4random()%[self.detailDataSourceList count];
            [self updateCurrentDetailDataSource:self.detailDataSourceList[rand]];
        }
    }else{
        NSError *error = [NSError errorWithDomain:@"Cannot fetch Category List data" code:-9999 userInfo:nil];
        if (self.currentCompleteHandler) {
            self.currentCompleteHandler(error, @"", NO, NO);
            self.currentCompleteHandler = nil;
        }
    }
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
    NSInteger errorCode = [responseParams getInt:KeyResponseResult];
    if (errorCode != 0) {
        
    }else{
        if (self.shouldShowLatest) {
            [self updateCurrentDetailDataSource:[self.detailDataSourceList objectAtIndex:[self.detailDataSourceList count] -1]];
            self.shouldShowLatest = NO;
        }
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
        if ([error.domain isEqualToString:GalleryScreenDetailError_fullyLoaded]) {
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
