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
#import "AppConfiguration.h"

@interface NewsScreenDataSource()<TenpossCommunicatorDelegate, SimpleDataSourceDelegate>

@end

@implementation NewsScreenDataSource

#pragma mark - Public methods

- (void)fetchDataWithCompleteHandler:(TabDataCompleteHandler)handler{
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

#pragma mark - Communicator
-(void)loadNewsCategoryList{
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    NSString *store_id = [appConfig getStoreId];
    NewsCategoryObject *newsCate = [NewsCategoryObject new];
    newsCate.store_id = [store_id integerValue];
    NewsScreenDetailDataSource *detailDataSource = [[NewsScreenDetailDataSource alloc]initWithDelegate:self andNewsCategory:newsCate];
    [self.detailDataSourceList addObject:detailDataSource];
    
    if (self.shouldShowLatest) {
        NSInteger lastSourceIndex = [self.detailDataSourceList count] -1;
        [self updateCurrentDetailDataSource:self.detailDataSourceList[lastSourceIndex]];
        self.shouldShowLatest = NO;
    }else{
        NSInteger rand = arc4random()%[self.detailDataSourceList count];
        [self updateCurrentDetailDataSource:self.detailDataSourceList[rand]];
    }

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
