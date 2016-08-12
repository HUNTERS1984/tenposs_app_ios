//
//  NewsScreenDataSource.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/12/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NewsScreenDetailDataSource.h"

#define NewsScreenError_isLast    @"this is last category"
#define NewsScreenError_isFirst    @"this is first category"
#define NewsScreenError_duplicate    @"duplicate category"

typedef void (^NewsDataCompleteHandler)(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious);

@interface NewsScreenDataSource : NSObject
@property (strong, nonatomic)UICollectionView *collectionView;

@property (strong, nonatomic) NewsScreenDetailDataSource *activeDetailDataSource;

- (instancetype)initAndShouldShowLatest:(BOOL)shouldShowLatest;

-(void)fetchDataWithCompleteHandler:(NewsDataCompleteHandler)handler;
-(void)changeToNextDetailDataSourceWithCompleteHandler:(NewsDataCompleteHandler)handler;
-(void)changeToPreviousDetailDataSourceWithCompleteHandler:(NewsDataCompleteHandler)handler;
-(void)loadMoreDataWithCompleteHandler:(NewsDataCompleteHandler)handler;

@end
