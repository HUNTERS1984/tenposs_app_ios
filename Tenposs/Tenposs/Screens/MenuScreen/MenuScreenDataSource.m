//
//  MenuScreenDataSource.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "MenuScreenDataSource.h"
#import "MenuCommunicator.h"
#import "Item_Cell_News.h"

@interface MenuScreenDataSource()

@property (strong, nonatomic) MenuCategoryModel *mainData;

@end

@implementation MenuScreenDataSource

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
    
}

- (NSInteger)numberOfItem{
    return [self.mainData.items count];
}

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.mainData.items objectAtIndex:indexPath.row];
}

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth{
    return CGSizeMake(superWidth, [Item_Cell_News getCellHeightWithWidth:superWidth]);
}

- (CGSize)sizeForHeaderAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}

- (CGSize)sizeForFooterAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}


@end
