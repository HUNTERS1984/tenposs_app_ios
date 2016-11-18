//
//  Item_Cell_Photo_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_Photo_t2.h"
#import "Item_Cell_Photo.h"
#import "AppConfiguration.h"


#define t2_Product_Margin  8
#define t2_Product_Show    2.5
#define t2_Product_header  44

@interface Item_Cell_Photo_t2()

@property (assign, nonatomic) CGFloat itemWidth, itemHeight;

@end

@implementation Item_Cell_Photo_t2

- (void)awakeFromNib {
    [super awakeFromNib];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Photo class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Photo class])];
}

- (void)configureCellWithData:(NSObject *)data{
    NSAssert(false, @"Should only implement: -configureCellWithData:(NSObject *)data productSelectHandler:(productSelectHandler)productHandler andHeaderSelectHandler:(headerSelectHandler)headerHandler ");
}

- (void)configureCellWithData:(NSObject *)data photoSelectHandler:(photoSelectHandler)photoHandler andHeaderSelectHandler:(headerSelectHandler)headerHandler{
    if (![data isKindOfClass:[NSMutableArray class]]) {
        return;
    }
    NSMutableArray *photos = (NSMutableArray *)data;
    
    if ([photos count] <= 0) {
        return;
    }else{
        _photos = photos;
        _photoHandler = photoHandler;
        _headerHandler = headerHandler;
    }
}

#pragma mark - UICollectionViewDataSource

- (PhotoObject *)photoForIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    if (_photos) {
        return [_photos objectAtIndex:index];
    }else{
        return nil;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photos?[_photos count]:0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Item_Cell_Photo *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Photo class]) forIndexPath:indexPath];
    PhotoObject *photo = [self photoForIndexPath:indexPath];
    
    if(cell && photo){
        [cell configureCellWithData:photo];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoObject *photo = [self photoForIndexPath:indexPath];
    if(photo){
        if (_photoHandler) {
            _photoHandler(photo);
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_itemWidth == 0 || _itemHeight == 0) {
        CGFloat fullWidth = collectionView.frame.size.width;
        
        CGFloat availableItemWidth = fullWidth - (3 * t2_Product_Margin);
        
        if (_itemWidth == 0) {
            _itemWidth = availableItemWidth/t2_Product_Show;
        }
        
        if (_itemHeight == 0) {
            _itemHeight = [Item_Cell_Photo getCellHeightWithWidth:_itemWidth];
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
    
    itemHeight = [Item_Cell_Photo getCellHeightWithWidth:itemWidth];
    
    CGFloat fullHeight = t2_Product_header + 2*t2_Product_Margin + itemHeight + 8;
    
    return CGSizeMake(fullWidth, fullHeight);
}

+ (CGFloat)getCellHeightWithWidth:(CGFloat)width{
    CGFloat availableItemWidth = width - (3 * t2_Product_Margin);
    
    CGFloat itemWidth, itemHeight;
    
    itemWidth = availableItemWidth/t2_Product_Show;
    
    itemHeight = [Item_Cell_Photo getCellHeightWithWidth:itemWidth];
    
    CGFloat fullHeight = t2_Product_header + 2*t2_Product_Margin + itemHeight + 8;
    
    return fullHeight;
}

- (IBAction)headerClicked:(id)sender {
    if (_headerHandler) {
        _headerHandler(APP_MENU_PHOTO_GALLERY);
    }
}

@end
