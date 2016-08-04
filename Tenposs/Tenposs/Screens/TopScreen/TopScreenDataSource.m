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

@property (strong, nonatomic)NSMutableArray *topItems;
@property (strong, nonatomic)NSMutableArray *productItems;
@property (strong, nonatomic)NSMutableArray *galleryItems;
@property (strong, nonatomic)NSMutableArray *newsItems;
@property (strong, nonatomic)NSMutableArray *shopItems;

@end

@implementation TopScreenDataSource

-(instancetype)initWithDelegate: (id <TopScreenDataSourceDelegate>) delegate{
    
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)registerClassForCollectionView:(UICollectionView *)collection{
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Product class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_News class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_News class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Photo class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Photo class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_ShopInfo class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_ShopInfo class])];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger numberOfSection = 0;
    
    if (_topItems && [_topItems count] > 0) {
        numberOfSection += 1;
    }
    
    if (_productItems && [_productItems count] > 0) {
        numberOfSection += 1;
    }
    
    if (_galleryItems && [_galleryItems count] > 0) {
        numberOfSection += 1;
    }
    
    if (_newsItems && [_newsItems count] > 0) {
        numberOfSection += 1;
    }
    
    if (_shopItems && [_shopItems count] > 0) {
        numberOfSection += 1;
    }
    
    return numberOfSection;
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

- (void)fetchContent{
    [self loadProducts];
    [self loadTopItem];
    [self loadGallery];
    [self loadShopInformation];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(dataLoadedWithError:)]){
        [self.delegate dataLoadedWithError:nil];
    }
}

- (void)loadProducts{
    
}

- (void)loadTopItem{
    
}

- (void)loadGallery{

}

- (void)loadShopInformation{
    
}

@end
