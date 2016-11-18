//
//  SimpleDataSource.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SimpleDataSource.h"

@implementation SimpleDataSource

- (instancetype)init{
    self = [super init];
    return self;
}

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _requestArray = (NSMutableArray<TenpossCommunicator *> *) [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) cancelOldRequest{
    if(self.requestArray != nil){
        while ([self.requestArray count] > 0) {
            TenpossCommunicator *request = [self.requestArray objectAtIndex:0];
            [request cancelRequest];
            [self.requestArray removeObject:request];
        }
    }
}

-(void)reloadDataSource{
    NSAssert(NO, @"Should be implemented");
}

- (void)loadData{
    NSAssert(NO, @"Should be implemented");
}

- (void)registerClassForCollectionView:(UICollectionView *)collection{
    NSAssert(NO, @"Should be implemented");
}

- (NSInteger)numberOfItem{
    NSAssert(NO, @"Should be implemented");
    return 0;
}

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath{
    NSAssert(NO, @"Should be implemented");
    return nil;
}

- (BOOL)isEqualTo:(SimpleDataSource *)second{
    NSAssert(NO, @"Should be implemented");
    return NO;
}

- (UIEdgeInsets)insetForSection:(NSInteger)section{
    NSAssert(NO, @"Should be implemented");
    return UIEdgeInsetsZero;
}

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth{
    NSAssert(NO, @"Should be implemented");
    return CGSizeZero;
}

- (CGSize)sizeForHeaderAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    NSAssert(NO, @"Should be implemented");
    return CGSizeZero;
}

- (CGSize)sizeForFooterAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    NSAssert(NO, @"Should be implemented");
    return CGSizeZero;
}

- (CGFloat)minimumLineSpacingForSection:(NSInteger)section{
    NSAssert(NO, @"Should be implemented");
    return 0;
}

- (CGFloat)minimumInteritemSpacingForSection:(NSInteger)section{
    NSAssert(NO, @"Should be implemented");
    return 0;
}

#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self numberOfItem];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSAssert(NO, @"Should be implemented");
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSAssert(NO, @"Should be implemented");
    return 1;
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSAssert(NO, @"Should be implemented");
    return nil;
}



@end
