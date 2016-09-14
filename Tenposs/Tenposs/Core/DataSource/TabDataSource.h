//
//  TabDataSource.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleDataSource.h"
#import <UIKit/UIKit.h>

typedef void (^TabDataCompleteHandler)(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious);

@interface TabDataSource : NSObject

@property (strong, nonatomic)UICollectionView *collectionView;

@property (strong, nonatomic) SimpleDataSource *activeDetailDataSource;

@property (strong, nonatomic) NSMutableArray<SimpleDataSource *> *detailDataSourceList;

@property (assign, nonatomic) BOOL shouldShowLatest;

@property (assign, nonatomic) NSInteger currentDetailDataSourceIndex;

@property (strong, nonatomic) TabDataCompleteHandler currentCompleteHandler;

- (instancetype)initAndShouldShowLatest:(BOOL)shouldShowLatest;

-(void)fetchDataWithCompleteHandler:(TabDataCompleteHandler)handler;

-(void)changeToNextDetailDataSourceWithCompleteHandler:(TabDataCompleteHandler)handler;

-(void)changeToPreviousDetailDataSourceWithCompleteHandler:(TabDataCompleteHandler)handler;

-(void)loadMoreDataWithCompleteHandler:(TabDataCompleteHandler)handler;

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath;

- (void)reloadDataWithCompleteHandler:(TabDataCompleteHandler)handler;

- (void)updateCurrentDetailDataSource:(SimpleDataSource *)detail;

- (BOOL)detailDataSourceHasNext:(SimpleDataSource *)dataSource;

- (BOOL)detailDataSourceHasPrevious:(SimpleDataSource *)dataSource;

- (void)resetData;

@end
