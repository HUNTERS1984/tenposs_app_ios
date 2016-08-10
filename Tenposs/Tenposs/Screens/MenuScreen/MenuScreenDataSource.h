//
//  MenuScreenDataSource.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/9/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuCommunicator.h"
#import "MenuScreenDetailDataSource.h"
#import <UIKit/UIKit.h>
#import "MockupData.h"

#define MenuScreenError_isLast    @"this is last category"
#define MenuScreenError_isFirst    @"this is first category"
#define MenuScreenError_duplicate    @"duplicate category"

typedef void (^MenuDataCompleteHandler)(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious);

//@protocol MenuSreenDataSourceDelegate <NSObject>
//
//-(void)fetchDataCompleteWithError:(NSError *)error andHandler;
//- (void)startChangingDetailDataSource:(MenuScreenDetailDataSource *)fromDataSource to:(MenuScreenDetailDataSource *)toDataSource;
//- (void)endChangingDetailDataSource;
//
//@end

@interface MenuScreenDataSource : NSObject

@property (strong, nonatomic)UICollectionView *collectionView;

@property (strong, nonatomic) MenuScreenDetailDataSource *activeDetailDataSource;

- (instancetype)initAndShouldShowLatest:(BOOL)shouldShowLatest;

-(void)fetchDataWithCompleteHandler:(MenuDataCompleteHandler)handler;
-(void)changeToNextDetailDataSourceWithCompleteHandler:(MenuDataCompleteHandler)handler;
-(void)changeToPreviousDetailDataSourceWithCompleteHandler:(MenuDataCompleteHandler)handler;
-(void)loadMoreDataWithCompleteHandler:(MenuDataCompleteHandler)handler;

@end
