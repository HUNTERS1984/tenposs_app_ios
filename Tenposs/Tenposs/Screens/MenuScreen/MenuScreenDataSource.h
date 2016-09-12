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
#import "MenuCommunicator.h"

typedef void (^MenuDataCompleteHandler)(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious);

@interface MenuScreenDataSource : NSObject <TenpossCommunicatorDelegate>

@property (strong, nonatomic)UICollectionView *collectionView;

@property (strong, nonatomic) MenuScreenDetailDataSource *activeDetailDataSource;

- (instancetype)initAndShouldShowLatest:(BOOL)shouldShowLatest;

-(void)fetchDataWithCompleteHandler:(MenuDataCompleteHandler)handler;
-(void)changeToNextDetailDataSourceWithCompleteHandler:(MenuDataCompleteHandler)handler;
-(void)changeToPreviousDetailDataSourceWithCompleteHandler:(MenuDataCompleteHandler)handler;
-(void)loadMoreDataWithCompleteHandler:(MenuDataCompleteHandler)handler;
- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath;
@end
