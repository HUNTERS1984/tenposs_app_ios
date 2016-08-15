//
//  NewsScreenDataSource.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/12/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "NewsScreenDataSource.h"
#import "TenpossCommunicator.h"
#import "MockupData.h"
#import "NewsCommunicator.h"

@interface NewsScreenDataSource()<TenpossCommunicatorDelegate, SimpleDataSourceDelegate>

@property (strong, nonatomic) NSMutableArray<NewsScreenDetailDataSource *> *detailDataSourceList;
@property BOOL shouldShowLatest;
@property NSInteger currentDetailDataSourceIndex;
@property NewsDataCompleteHandler currentCompleteHandler;

@end

@implementation NewsScreenDataSource

- (instancetype)initAndShouldShowLatest:(BOOL)shouldShowLatest{
    self = [super init];
    if (self) {
        self.shouldShowLatest = shouldShowLatest;
        self.detailDataSourceList = (NSMutableArray<NewsScreenDetailDataSource *> *)[[NSMutableArray alloc]init];
        self.currentDetailDataSourceIndex = -1;
    }
    return self;
}

#pragma mark - Public methods
- (void)fetchDataWithCompleteHandler:(NewsDataCompleteHandler)handler{
    self.currentCompleteHandler = handler;
    if ([self.detailDataSourceList count] <= 0) {
        [self loadNewsCategoryList];
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

- (void)changeToNextDetailDataSourceWithCompleteHandler:(NewsDataCompleteHandler)handler{
    if (![self detailDataSourceHasNext:self.activeDetailDataSource]) {
        NSError *error = [NSError errorWithDomain:NewsScreenError_isLast code:-9900 userInfo:nil];
        handler(error, nil, NO,YES);
        return;
    }
    NSInteger indexToChangeTo = [self.detailDataSourceList indexOfObject:self.activeDetailDataSource] + 1;
    NewsScreenDetailDataSource *sourceToChangeTo = self.detailDataSourceList[indexToChangeTo];
    if (![sourceToChangeTo.mainData.title isEqualToString:self.activeDetailDataSource.mainData.title]) {
        self.currentCompleteHandler = handler;
        [self updateCurrentDetailDataSource:sourceToChangeTo];
    }else{
        NSError *error = [NSError errorWithDomain:NewsScreenError_duplicate code:-9902 userInfo:nil];
        handler(error, nil, [self detailDataSourceHasNext:self.activeDetailDataSource],[self detailDataSourceHasPrevious:self.activeDetailDataSource]);
    }
}

- (void)changeToPreviousDetailDataSourceWithCompleteHandler:(NewsDataCompleteHandler)handler{
    if (![self detailDataSourceHasPrevious:self.activeDetailDataSource]) {
        NSError *error = [NSError errorWithDomain:NewsScreenError_isFirst code:-9901 userInfo:nil];
        handler(error, nil, YES,NO);
        return;
    }
    NSInteger indexToChangeTo = [self.detailDataSourceList indexOfObject:self.activeDetailDataSource] -1;
    NewsScreenDetailDataSource *sourceToChangeTo = self.detailDataSourceList[indexToChangeTo];
    if (![sourceToChangeTo.mainData.title isEqualToString:self.activeDetailDataSource.mainData.title]) {
        self.currentCompleteHandler = handler;
        [self updateCurrentDetailDataSource:sourceToChangeTo];
    }else{
        NSError *error = [NSError errorWithDomain:NewsScreenError_duplicate code:-9902 userInfo:nil];
        handler(error, nil, [self detailDataSourceHasNext:self.activeDetailDataSource],[self detailDataSourceHasPrevious:self.activeDetailDataSource]);
    }
}

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.activeDetailDataSource itemAtIndexPath:indexPath];
}

- (void)loadMoreDataWithCompleteHandler:(NewsDataCompleteHandler)handler{
    
}

#pragma mark - Communicator
-(void)loadNewsCategoryList{
    NSData *data = [MockupData fetchDataWithResourceName:@"news_list"];
    NSError *error = nil;
    
    NewsCategoryListModel *menuList = [[NewsCategoryListModel alloc]initWithData:data error:&error];
    if (!error && menuList && [menuList.items count] > 0) {
        for (NewsCategoryObject *category in menuList.items) {
            NewsScreenDetailDataSource *detailDataSource = [[NewsScreenDetailDataSource alloc]initWithDelegate:self andNewsCategory:category];
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

- (void)updateCurrentDetailDataSource:(NewsScreenDetailDataSource *)detail{
    self.activeDetailDataSource = detail;
    [self.activeDetailDataSource registerClassForCollectionView:self.collectionView];
    self.currentDetailDataSourceIndex = [self.detailDataSourceList indexOfObject:detail];
    [self.activeDetailDataSource loadData];
}

- (BOOL)detailDataSourceHasNext:(NewsScreenDetailDataSource *)dataSource {
    NSInteger detailDataSourceCount = [self.detailDataSourceList count];
    if ([(self.detailDataSourceList[detailDataSourceCount -1]).mainData.title isEqualToString:dataSource.mainData.title] && [self.detailDataSourceList count] > 1) {
        return NO;
    }
    return YES;
}

- (BOOL)detailDataSourceHasPrevious:(NewsScreenDetailDataSource *)dataSource{
    if ([(self.detailDataSourceList[0]).mainData.title isEqualToString:dataSource.mainData.title] && [self.detailDataSourceList count] > 1) {
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
    NewsScreenDetailDataSource *dataSource = (NewsScreenDetailDataSource *)executor;
    if (!dataSource) {
        //TODO: handle nil detailDataSource
    }
    NSString *detailDataSourceTitle = dataSource.mainData.title;
    if (self.currentCompleteHandler) {
        if ([error.domain isEqualToString:NewsScreenDetailError_fullyLoaded]) {
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
