//
//  TabDataSource.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TabDataSource.h"
#import "CommunicatorConst.h"

@interface TabDataSource()
@end

@implementation TabDataSource

- (instancetype)initAndShouldShowLatest:(BOOL)shouldShowLatest{
    self = [super init];
    if (self) {
        self.shouldShowLatest = shouldShowLatest;
        self.detailDataSourceList = (NSMutableArray<SimpleDataSource *> *)[[NSMutableArray alloc]init];
        self.currentDetailDataSourceIndex = -1;
    }
    return self;
}

- (void)reloadDataWithCompleteHandler:(TabDataCompleteHandler)handler{
    [self resetData];
    [self fetchDataWithCompleteHandler:handler];
}

- (void)resetData{
    [_detailDataSourceList removeAllObjects];
}

- (void)loadMoreDataWithCompleteHandler:(TabDataCompleteHandler)handler{
    self.currentCompleteHandler = handler;
    [_activeDetailDataSource loadData];
}

- (void)fetchDataWithCompleteHandler:(TabDataCompleteHandler)handler{
    NSAssert(NO, @"Should be implemented!");
}

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath{
    return [_activeDetailDataSource itemAtIndexPath:indexPath];
}

- (void)changeToNextDetailDataSourceWithCompleteHandler:(TabDataCompleteHandler)handler{
    if (![self detailDataSourceHasNext:self.activeDetailDataSource]) {
        NSError *error = [NSError errorWithDomain:@"" code:ERROR_DETAIL_DATASOURCE_IS_LAST userInfo:nil];
        handler(error, nil, NO,YES);
        return;
    }
    NSInteger indexToChangeTo = [self.detailDataSourceList indexOfObject:self.activeDetailDataSource] + 1;
    SimpleDataSource *sourceToChangeTo = self.detailDataSourceList[indexToChangeTo];
    if (![sourceToChangeTo isEqualTo:_activeDetailDataSource]) {
        self.currentCompleteHandler = handler;
        [self updateCurrentDetailDataSource:sourceToChangeTo];
    }else{
        NSError *error = [NSError errorWithDomain:@"" code:ERROR_DETAIL_DATASOURCE_IS_DUBLICATED userInfo:nil];
        handler(error, nil, [self detailDataSourceHasNext:self.activeDetailDataSource],[self detailDataSourceHasPrevious:self.activeDetailDataSource]);
    }
}

- (void)changeToPreviousDetailDataSourceWithCompleteHandler:(TabDataCompleteHandler)handler{
    if (![self detailDataSourceHasPrevious:self.activeDetailDataSource]) {
        NSError *error = [NSError errorWithDomain:@"" code:ERROR_DETAIL_DATASOURCE_IS_FIRST userInfo:nil];
        handler(error, nil, YES,NO);
        return;
    }
    NSInteger indexToChangeTo = [self.detailDataSourceList indexOfObject:self.activeDetailDataSource] -1;
    SimpleDataSource *sourceToChangeTo = self.detailDataSourceList[indexToChangeTo];
    if (![sourceToChangeTo isEqualTo:_activeDetailDataSource]) {
        self.currentCompleteHandler = handler;
        [self updateCurrentDetailDataSource:sourceToChangeTo];
    }else{
        NSError *error = [NSError errorWithDomain:@"" code:ERROR_DETAIL_DATASOURCE_IS_DUBLICATED userInfo:nil];
        handler(error, nil, [self detailDataSourceHasNext:self.activeDetailDataSource],[self detailDataSourceHasPrevious:self.activeDetailDataSource]);
    }
}

- (void)updateCurrentDetailDataSource:(SimpleDataSource *)detail{
    self.activeDetailDataSource = detail;
    [self.activeDetailDataSource registerClassForCollectionView:self.collectionView];
    self.currentDetailDataSourceIndex = [self.detailDataSourceList indexOfObject:detail];
    [self.activeDetailDataSource loadData];
}

- (BOOL)detailDataSourceHasNext:(SimpleDataSource *)dataSource {
    NSInteger detailDataSourceCount = [self.detailDataSourceList count];
    if ([(self.detailDataSourceList[detailDataSourceCount -1]) isEqualTo:dataSource] && [self.detailDataSourceList count] > 1) {
        return NO;
    }else if (detailDataSourceCount == 1){
        return NO;
    }
    return YES;
}

- (BOOL)detailDataSourceHasPrevious:(SimpleDataSource *)dataSource{
    if ([(self.detailDataSourceList[0]) isEqualTo:dataSource] && [self.detailDataSourceList count] > 1) {
        return NO;
    }else if ([self.detailDataSourceList count] == 1){
        return NO;
    }
    return YES;
}


@end
