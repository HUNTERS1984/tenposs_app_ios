//
//  Item_Cell_Product_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_Product_t2.h"
#import "Item_Cell_Product_Item_t2.h"
#import "AppConfiguration.h"

#define t2_Product_Margin  8
#define t2_Product_Show    2.5
#define t2_Product_header  44

@interface Item_Cell_Product_t2()

@property (strong, nonatomic)NSMutableArray *products;
@property (assign, nonatomic) CGFloat itemWidth, itemHeight;

@end

@implementation Item_Cell_Product_t2

- (void)awakeFromNib {
    [super awakeFromNib];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Product_Item_t2 class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product_Item_t2 class])];
}

- (void)configureCellWithData:(NSObject *)data{
    NSAssert(false, @"Should only implement: -configureCellWithData:(NSObject *)data productSelectHandler:(productSelectHandler)productHandler andHeaderSelectHandler:(headerSelectHandler)headerHandler ");
}

- (void)configureCellWithData:(NSObject *)data productSelectHandler:(productSelectHandler)productHandler andHeaderSelectHandler:(headerSelectHandler)headerHandler{
    if (![data isKindOfClass:[NSMutableArray class]]) {
        return;
    }
    NSMutableArray *products = (NSMutableArray *)data;
    
    if ([products count] <= 0) {
        return;
    }else{
        _products = products;
        _productHandler = productHandler;
        _headerHandler = headerHandler;
    }
}

#pragma mark - UICollectionViewDataSource

- (ProductObject *)productForIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    if (_products) {
        return [_products objectAtIndex:index];
    }else{
        return nil;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _products?[_products count]:0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Item_Cell_Product_Item_t2 *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product_Item_t2 class]) forIndexPath:indexPath];
    ProductObject *product = [self productForIndexPath:indexPath];
    
    if(cell && product){
        [cell configureCellWithData:product];
    
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductObject *product = [self productForIndexPath:indexPath];
    if(product){
        if (_productHandler) {
            _productHandler(product);
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_itemWidth == 0 || _itemHeight == 0) {
        CGFloat fullWidth = self.bounds.size.width;
        
        CGFloat availableItemWidth = fullWidth - (3 * t2_Product_Margin);
        
        if (_itemWidth == 0) {
            _itemWidth = availableItemWidth/t2_Product_Show;
        }
        
        if (_itemHeight == 0) {
            _itemHeight = [Item_Cell_Product_Item_t2 getCellHeightWithWidth:_itemWidth];
        }
    }
    return CGSizeMake(_itemWidth, _itemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 8, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

+ (CGSize)calculateSizeWithWidth:(CGFloat)fullWidth{
    
    CGFloat availableItemWidth = fullWidth - (3 * t2_Product_Margin);
    
    CGFloat itemWidth, itemHeight;
    
    itemWidth = availableItemWidth/t2_Product_Show;
    
    itemHeight = [Item_Cell_Product_Item_t2 getCellHeightWithWidth:itemWidth];
    
    CGFloat fullHeight = t2_Product_header + itemHeight; //2*t2_Product_Margin;
    
    return CGSizeMake(fullWidth, fullHeight);
}

+ (CGFloat)getCellHeightWithWidth:(CGFloat)width{
    
    CGFloat availableItemWidth = width - (3 * t2_Product_Margin);
    
    CGFloat itemWidth, itemHeight;
    
    itemWidth = availableItemWidth/t2_Product_Show;
    
    itemHeight = [Item_Cell_Product_Item_t2 getCellHeightWithWidth:itemWidth];
    
    CGFloat fullHeight = t2_Product_header + itemHeight + 16; //2*t2_Product_Margin;
    
    return fullHeight;
}

- (IBAction)onHeaderClicked:(id)sender {
    if (_headerHandler) {
        _headerHandler(APP_MENU_MENU);
    }
}

@end
