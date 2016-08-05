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
#import "TenpossCommunicator.h"

@interface TopScreenDataSource()<TenpossCommunicatorDelegate>

@property (strong, nonatomic)NSMutableArray *sectionArray;
@property (strong, nonatomic)NSMutableArray *topItems;
@property (strong, nonatomic)NSMutableArray *productItems;
@property (strong, nonatomic)NSMutableArray *galleryItems;
@property (strong, nonatomic)NSMutableArray *newsItems;
@property (strong, nonatomic)NSMutableArray *shopItems;

@property (strong, nonatomic)NSMutableArray *currentRequests;

@end

@implementation TopScreenDataSource

-(instancetype)initWithDelegate: (id <TopScreenDataSourceDelegate>) delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (NSMutableArray *)sectionDataForSection:(NSInteger)section{
    if (section >= [_sectionArray count]) {
        return nil;
    }
    NSMutableArray *sectionData = [_sectionArray objectAtIndex:section];
    return sectionData;
}

- (NSObject *)dataAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *sectionData = [self sectionDataForSection:indexPath.section];
    if (sectionData) {
        return [sectionData objectAtIndex:indexPath.row];
    }
    return nil;
}

- (NSString *)classStringForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *item = [self dataAtIndexPath:indexPath];
    NSString *classString = @"";
    if ([item isKindOfClass:[ProductObject class]]) {
        
    }else if([item isKindOfClass:[TopObject class]]){
        
    }else if([item isKindOfClass:[PhotoObject class]]){
        
    }else if([item isKindOfClass:[ShopObject class]]){
        
    }
    return NSStringFromClass([item class]);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section >= [_sectionArray count]) {
        return 0;
    }
    NSMutableArray *sectionData = [_sectionArray objectAtIndex:section];
    if(sectionData){
        return [sectionData count];
    }else{
        NSAssert(false, @"Wrong section index or sectionArray doesn't contain this section");
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = nil;
    NSObject *item = [self dataAtIndexPath:indexPath];
    
    if ([item isKindOfClass:[ProductObject class]]) {
        
    }else if([item isKindOfClass:[TopObject class]]){
        
    }else if([item isKindOfClass:[PhotoObject class]]){
    
    }else if([item isKindOfClass:[ShopObject class]]){
        
    }
    
    
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - Public Methods

- (void)registerClassForCollectionView:(UICollectionView *)collection{
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Product class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_News class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_News class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Photo class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Photo class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_ShopInfo class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_ShopInfo class])];
}

- (void)fetchContent{
    [self loadTopItem];
    [self loadProducts];
    [self loadTopItem];
    [self loadGallery];
    [self loadShopInformation];
}

#pragma mark - Communication

- (void)loadTopItems{
    
}

- (void)loadProducts{
    
}

- (void)loadTopItem{
    
}

- (void)loadGallery{

}

- (void)loadShopInformation{
    
}

#pragma mark - TenpossCommunicatorDelegate

- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    if(self.delegate && [self.delegate respondsToSelector:@selector(dataLoadedWithError:)]){
        [self.delegate dataLoadedWithError:nil];
    }
}

- (void)begin:(TenpossCommunicator*)request data:(Bundle*) responseParams{

}

-( void)cancelAllRequest{

}


@end
