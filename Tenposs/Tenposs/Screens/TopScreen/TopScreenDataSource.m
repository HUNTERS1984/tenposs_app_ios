//
//  TopScreenDataSource.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/29/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TopScreenDataSource.h"
#import "Item_Cell_Product.h"
#import "Item_Cell_Photo.h"
#import "Item_Cell_News.h"
#import "Item_Cell_ShopInfo.h"

@interface TopScreenDataSource()

@end

@implementation TopScreenDataSource

-(instancetype)initWithDelegate: (id <TopScreenDataSourceDelegate>) delegate{
    
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

@end
