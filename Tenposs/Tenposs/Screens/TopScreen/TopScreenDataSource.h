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

- (void)dataLoadedSuccessAtIndexPath:(NSIndexPath *)indexPath;

- (void)dataLoadedFailedAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TopScreenDataSource : NSObject <UICollectionViewDataSource>

@property(weak, nonatomic) id <TopScreenDataSourceDelegate> delegate;

-(instancetype)initWithDelegate: (id <TopScreenDataSourceDelegate>) delegate;

@end
