//
//  TopScreenDataSource.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/29/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TopScreenDataSourceDelegate <NSObject>

- (void)dataLoadedWithError:(NSError *)error;

- (void)needRefreshItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)needRefreshSectionAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TopScreenDataSource : NSObject <UICollectionViewDataSource>

@property(weak, nonatomic) id <TopScreenDataSourceDelegate> delegate;

- (void)registerClassForCollectionView:(UICollectionView *)collection;

-(instancetype)initWithDelegate: (id <TopScreenDataSourceDelegate>) delegate;

- (void)fetchContent;

@end
