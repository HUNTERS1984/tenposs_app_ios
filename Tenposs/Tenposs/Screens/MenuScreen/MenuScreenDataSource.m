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

@end

@implementation MenuScreenDataSource

#pragma mark - Public methods

- (void)fetchDataWithCompleteHandler:(TabDataCompleteHandler)handler{
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
            if (self.currentDetailDataSourceIndex > 0){
                if ([self.detailDataSourceList count] <= self.currentDetailDataSourceIndex) {
                    self.currentDetailDataSourceIndex = [self.detailDataSourceList count];
                }
                [self updateCurrentDetailDataSource:[self.detailDataSourceList objectAtIndex:self.currentDetailDataSourceIndex]];
                self.shouldShowLatest = NO;
            }else {
                if(self.shouldShowLatest) {
                   [self updateCurrentDetailDataSource:[self.detailDataSourceList objectAtIndex:[self.detailDataSourceList count] -1]];
                   self.shouldShowLatest = NO;
                }
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
