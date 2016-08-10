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

@interface MenuScreenDataSource()<TenpossCommunicatorDelegate, SimpleDataSourceDelegate>

@property (strong, nonatomic) NSMutableArray<MenuScreenDetailDataSource *> *detailDataSourceList;
@property BOOL shouldShowLatest;
@property NSInteger currentDetailDataSourceIndex;
@property MenuDataCompleteHandler currentCompleteHandler;

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
        NSError *error = [NSError errorWithDomain:MenuScreenError_isLast code:-9900 userInfo:nil];
        handler(error, nil, NO,YES);
        return;
    }
    NSInteger indexToChangeTo = [self.detailDataSourceList indexOfObject:self.activeDetailDataSource] + 1;
    MenuScreenDetailDataSource *sourceToChangeTo = self.detailDataSourceList[indexToChangeTo];
    if (sourceToChangeTo.mainData.menu_id != self.activeDetailDataSource.mainData.menu_id) {
        self.currentCompleteHandler = handler;
        [self updateCurrentDetailDataSource:sourceToChangeTo];
    }else{
        NSError *error = [NSError errorWithDomain:MenuScreenError_duplicate code:-9902 userInfo:nil];
        handler(error, nil, [self detailDataSourceHasNext:self.activeDetailDataSource],[self detailDataSourceHasPrevious:self.activeDetailDataSource]);
    }
}

- (void)changeToPreviousDetailDataSourceWithCompleteHandler:(MenuDataCompleteHandler)handler{
    if (![self detailDataSourceHasPrevious:self.activeDetailDataSource]) {
        NSError *error = [NSError errorWithDomain:MenuScreenError_isFirst code:-9901 userInfo:nil];
        handler(error, nil, YES,NO);
        return;
    }
    NSInteger indexToChangeTo = [self.detailDataSourceList indexOfObject:self.activeDetailDataSource] -1;
    MenuScreenDetailDataSource *sourceToChangeTo = self.detailDataSourceList[indexToChangeTo];
    if (sourceToChangeTo.mainData.menu_id != self.activeDetailDataSource.mainData.menu_id) {
        self.currentCompleteHandler = handler;
        [self updateCurrentDetailDataSource:sourceToChangeTo];
    }else{
        NSError *error = [NSError errorWithDomain:MenuScreenError_duplicate code:-9902 userInfo:nil];
        handler(error, nil, [self detailDataSourceHasNext:self.activeDetailDataSource],[self detailDataSourceHasPrevious:self.activeDetailDataSource]);
    }
}

- (void)loadMoreDataWithCompleteHandler:(MenuDataCompleteHandler)handler{
    
}

#pragma mark - Communicator
-(void)loadMenuCategoryList{
    NSData *data = [MockupData fetchDataWithResourceName:@"menu_list"];
    NSError *error = nil;
    
    MenuListModel *menuList = [[MenuListModel alloc]initWithData:data error:&error];
    if (!error && menuList && [menuList.items count] > 0) {
        for (MenuCategoryModel *category in menuList.items) {
            MenuScreenDetailDataSource *detailDataSource = [[MenuScreenDetailDataSource alloc]initWithDelegate:self andMenuCategory:category];
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
    }
    return YES;
}

- (BOOL)detailDataSourceHasPrevious:(MenuScreenDetailDataSource *)dataSource{
    if ((self.detailDataSourceList[0]).mainData.menu_id == dataSource.mainData.menu_id && [self.detailDataSourceList count] > 1) {
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
    MenuScreenDetailDataSource *dataSource = (MenuScreenDetailDataSource *)executor;
    if (!dataSource) {
        //TODO: handle nil detailDataSource
    }
    NSString *detailDataSourceTitle = dataSource.mainData.title;
    if (self.currentCompleteHandler) {
        if ([error.domain isEqualToString:MenuScreenDetailError_fullyLoaded]) {
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
