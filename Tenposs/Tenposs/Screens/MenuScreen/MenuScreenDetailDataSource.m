//
//  MenuScreenDetailDataSource.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/9/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "MenuScreenDetailDataSource.h"
#import "MenuScreenDetailDataSource.h"
#import "Item_Cell_News.h"
#import "Item_Cell_Product.h"

#define SPACING_ITEM_PRODUCT 8

@interface MenuScreenDetailDataSource()

@end

@implementation MenuScreenDetailDataSource

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate andMenuCategory:(MenuCategoryModel *)menuCategory{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.mainData = menuCategory;
    }
    return self;
}

-(void)reloadDataSource{
    self.mainData.pageIndex = 0;
    [self.mainData removeAllProduct];
    self.mainData.totalitem = 0;
    [self loadData];
}

- (void)changeDataSourceTo:(MenuCategoryModel *)newMainData{
    self.mainData = nil;
    self.mainData = newMainData;
    [self loadData];
}

- (void)loadData{
    if (!self.mainData) {
        self.mainData = [MenuCategoryModel new];
    }
    if([self.mainData.items count] == self.mainData.totalitem){
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
            NSError *error = [NSError errorWithDomain:MenuScreenDetailError_fullyLoaded code:-9904 userInfo:nil];
            [self.delegate dataLoaded:self withError:error];
        }
        return;
    }
    ///TODO: real connection to server
    
    NSData *data = nil;
    
    if ([self.mainData.items count] <= 0) {
        data = [MockupData fetchDataWithResourceName:@"menu_items_1"];
    }else{
        data = [MockupData fetchDataWithResourceName:@"menu_items_2"];
    }
    
    NSError *error;
    MenuCategoryModel *menuData = [[MenuCategoryModel alloc] initWithData:data error:&error];
    
    if (error == nil) {
        if (menuData && [menuData.items count] > 0) {
            for (ProductObject *item in menuData.items) {
                NSString *title = [NSString stringWithFormat:@"%ld_%@",(long)self.mainData.menu_id,item.title];
                item.title = title;
                [self.mainData addProduct:item];
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
        [self.delegate dataLoaded:self withError:error];
    }
}

- (void)registerClassForCollectionView:(UICollectionView *)collection{
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Product class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product class])];
}

- (NSInteger)numberOfItem{
    return [self.mainData.items count];
}

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.mainData.items objectAtIndex:indexPath.row];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.mainData.items count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductObject *item = (ProductObject *)[self itemAtIndexPath:indexPath];
    Item_Cell_Product *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product class]) forIndexPath:indexPath];
    if (cell && item) {
        [cell configureCellWithData:item];
    }
    return cell;
}

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth{
    CGFloat width = (superWidth - 3*SPACING_ITEM_PRODUCT) / 2;
    CGFloat height = [Item_Cell_Product getCellHeightWithWidth:width];
    return CGSizeMake(width,height);
}

- (CGSize)sizeForHeaderAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}

- (CGSize)sizeForFooterAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}


@end
