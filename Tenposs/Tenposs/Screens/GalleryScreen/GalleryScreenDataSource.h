//
//  GalleryScreenDataSource.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/21/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GalleryScreenDetailDataSource.h"

typedef void (^GalleryDataCompleteHandler)(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious);

@interface GalleryScreenDataSource : NSObject

@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) GalleryScreenDetailDataSource *activeDetailDataSource;

- (instancetype) initAndShouldShowLatest:(BOOL)shouldShowLatest;

-(void)fetchDataWithCompleteHandler:(GalleryDataCompleteHandler)handler;
-(void)changeToNextDetailDataSourceWithCompleteHandler:(GalleryDataCompleteHandler)handler;
-(void)changeToPreviousDetailDataSourceWithCompleteHandler:(GalleryDataCompleteHandler)handler;
-(void)loadMoreDataWithCompleteHandler:(GalleryDataCompleteHandler)handler;

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath;


@end
