//
//  StaffScreenDataSource.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/11/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "StaffScreenDetailDataSource.h"


typedef void (^GalleryDataCompleteHandler)(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious);

@interface StaffScreenDataSource : NSObject


@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) StaffScreenDetailDataSource *activeDetailDataSource;

- (instancetype) initAndShouldShowLatest:(BOOL)shouldShowLatest;

-(void)fetchDataWithCompleteHandler:(GalleryDataCompleteHandler)handler;
-(void)changeToNextDetailDataSourceWithCompleteHandler:(GalleryDataCompleteHandler)handler;
-(void)changeToPreviousDetailDataSourceWithCompleteHandler:(GalleryDataCompleteHandler)handler;
-(void)loadMoreDataWithCompleteHandler:(GalleryDataCompleteHandler)handler;

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath;



@end
