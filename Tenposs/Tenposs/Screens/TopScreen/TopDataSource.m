//
//  TopDataSource.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TopDataSource.h"

@implementation TopDataSource

- (void)registerClassForCollectionView:(UICollectionView *)collection{
    NSAssert(NO, @"Should be implemented by subclasses!!!");
}

-(instancetype)initWithDelegate: (id <TopScreenDataSourceDelegate>) delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (NSObject *)dataAtIndexPath:(NSIndexPath *)indexPath{
    NSAssert(NO, @"Should be implemented by subclasses!!!");
    return nil;
}

- (void)fetchContent{
    NSAssert(NO, @"Should be implemented by subclasses!!!");
}

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth{
    NSAssert(NO, @"Should be implemented by subclasses!!!");
    return CGSizeZero;
}

- (CGSize)sizeForHeaderAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    NSAssert(NO, @"Should be implemented by subclasses!!!");
    return CGSizeZero;
}

- (CGSize)sizeForFooterAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    NSAssert(NO, @"Should be implemented by subclasses!!!");
    return CGSizeZero;
}

- (CGFloat)minimumLineSpacingForSection:(NSInteger)section{
    NSAssert(NO, @"Should be implemented by subclasses!!!");
    return 0;
}

- (CGFloat)minimumInteritemSpacingForSection:(NSInteger)section{
    NSAssert(NO, @"Should be implemented by subclasses!!!");
    return 0;
}

- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section{
    NSAssert(NO, @"Should be implemented by subclasses!!!");
    return UIEdgeInsetsZero;
}

@end
