//
//  MenuScreenDataSource.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/9/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "MenuScreenDataSource.h"
#import "MenuCommunicator.h"
#import "SimpleDataSource.h"
#import "CommunicatorConst.h"
#import "AppConfiguration.h"
#import "Utils.h"
#import "Const.h"

@interface MenuScreenDataSource()<TenpossCommunicatorDelegate, SimpleDataSourceDelegate>

@property (strong, nonatomic) NSMutableArray<MenuScreenDetailDataSource *> *detailDataSourceList;
@property (assign, nonatomic) BOOL shouldShowLatest;
@property (assign, nonatomic) NSInteger currentDetailDataSourceIndex;
@property (strong, nonatomic) MenuDataCompleteHandler currentCompleteHandler;

@end

@implementation MenuScreenDataSource

- (instancetype)initAndShouldShowLatest:(BOOL)shouldShowLatest{
    self = [super init];
    if (self) {
        self.shouldShowLatest = shouldShowLatest;
        self.detailDataSourceList = (NSMutableArray<MenuScreenDetailDataSource *> *)[[NSMutableArray alloc]init];
        self.currentDetailDataSourceIndex = -1;
    }
    return self;
}

#pragma mark - Public methods

- (void)fetchDataWithCompleteHandler:(MenuDataCompleteHandler)handler{
    self.currentCompleteHandler = handler;
    if ([self.detailDataSourceList count] <= 0) {
        [self loadMenuCategoryList];
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

- (void)changeToNextDetailDataSourceWithCompleteHandler:(MenuDataCompleteHandler)handler{
    if (![self detailDataSourceHasNext:self.activeDetailDataSource]) {
        NSError *error = [NSError errorWithDomain:@"" code:ERROR_DATASOURCE_IS_LAST userInfo:nil];
        handler(error, nil, NO,YES);
        return;
    }
    NSInteger indexToChangeTo = [self.detailDataSourceList indexOfObject:self.activeDetailDataSource] + 1;
    MenuScreenDetailDataSource *sourceToChangeTo = self.detailDataSourceList[indexToChangeTo];
    if (sourceToChangeTo.mainData.menu_id != self.activeDetailDataSource.mainData.menu_id) {
        self.currentCompleteHandler = handler;
        [self updateCurrentDetailDataSource:sourceToChangeTo];
    }else{
        NSError *error = [NSError errorWithDomain:@"" code:ERROR_DATASOURCE_IS_DUBLICATED userInfo:nil];
        handler(error, nil, [self detailDataSourceHasNext:self.activeDetailDataSource],[self detailDataSourceHasPrevious:self.activeDetailDataSource]);
    }
}

- (void)changeToPreviousDetailDataSourceWithCompleteHandler:(MenuDataCompleteHandler)handler{
    if (![self detailDataSourceHasPrevious:self.activeDetailDataSource]) {
        NSError *error = [NSError errorWithDomain:@"" code:ERROR_DATASOURCE_IS_FIRST userInfo:nil];
        handler(error, nil, YES,NO);
        return;
    }
    NSInteger indexToChangeTo = [self.detailDataSourceList indexOfObject:self.activeDetailDataSource] -1;
    MenuScreenDetailDataSource *sourceToChangeTo = self.detailDataSourceList[indexToChangeTo];
    if (sourceToChangeTo.mainData.menu_id != self.activeDetailDataSource.mainData.menu_id) {
        self.currentCompleteHandler = handler;
        [self updateCurrentDetailDataSource:sourceToChangeTo];
    }else{
        NSError *error = [NSError errorWithDomain:@"" code:ERROR_DATASOURCE_IS_DUBLICATED userInfo:nil];
        handler(error, nil, [self detailDataSourceHasNext:self.activeDetailDataSource],[self detailDataSourceHasPrevious:self.activeDetailDataSource]);
    }
}

- (void)loadMoreDataWithCompleteHandler:(MenuDataCompleteHandler)handler{
    
}

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.activeDetailDataSource itemAtIndexPath:indexPath];
}

#pragma mark - Communicator
-(void)loadMenuCategoryList{
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    NSString * store_id = [appConfig getStoreId];
    
    MenuCommunicator *request = [MenuCommunicator new];
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

- (void)updateCurrentDetailDataSource:(MenuScreenDetailDataSource *)detail{
    self.activeDetailDataSource = detail;
    [self.activeDetailDataSource registerClassForCollectionView:self.collectionView];
    self.currentDetailDataSourceIndex = [self.detailDataSourceList indexOfObject:detail];
    [self.activeDetailDataSource loadData];
}

- (BOOL)detailDataSourceHasNext:(MenuScreenDetailDataSource *)dataSource {
    NSInteger detailDataSourceCount = [self.detailDataSourceList count];
    if ((self.detailDataSourceList[detailDataSourceCount -1]).mainData.menu_id == dataSource.mainData.menu_id && [self.detailDataSourceList count] > 1) {
        return NO;
    }else if (detailDataSourceCount == 1){
        return NO;
    }
    return YES;
}

- (BOOL)detailDataSourceHasPrevious:(MenuScreenDetailDataSource *)dataSource{
    if ((self.detailDataSourceList[0]).mainData.menu_id == dataSource.mainData.menu_id && [self.detailDataSourceList count] > 1) {
        return NO;
    }else if ([self.detailDataSourceList count] == 1){
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
        MenuResponse *data = (MenuResponse *)[responseParams get:KeyResponseObject];
        if (data.items && [data.items count] > 0) {
            for (MenuCategoryModel *menu in data.items) {
                MenuScreenDetailDataSource *detailDataSource = [[MenuScreenDetailDataSource alloc]initWithDelegate:self andMenuCategory:menu];
                [self.detailDataSourceList addObject:detailDataSource];
            }
            if (self.shouldShowLatest) {
                [self updateCurrentDetailDataSource:[self.detailDataSourceList objectAtIndex:[self.detailDataSourceList count] -1]];
                self.shouldShowLatest = NO;
            }
            return;
        }else{
            error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_NO_CONTENT] code:ERROR_NO_CONTENT userInfo:nil];
        }
    }
    if (self.currentCompleteHandler) {
        self.currentCompleteHandler(error, @"", NO, NO);
        self.currentCompleteHandler = nil;
    }
}

#pragma mark - SimpleDataSourceDelegate
- (void)dataLoaded:(SimpleDataSource *)executor withError:(NSError *)error{
    MenuScreenDetailDataSource *dataSource = (MenuScreenDetailDataSource *)executor;
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
