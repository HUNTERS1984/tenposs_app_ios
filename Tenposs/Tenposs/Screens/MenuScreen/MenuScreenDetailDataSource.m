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
#import "Utils.h"

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
    self.mainData.pageIndex = 1;
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
    if([self.mainData.items count] > 0 && [self.mainData.items count] == self.mainData.totalitem){
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
            NSError *error = [NSError errorWithDomain:@"" code:ERROR_CONTENT_FULLY_LOADED userInfo:nil];
            [self.delegate dataLoaded:self withError:error];
        }
        return;
    }
    MenuItemCommunicator *request = [MenuItemCommunicator new];
    Bundle *params = [Bundle new];
    [params put:KeyAPI_APP_ID value:APP_ID];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    [params put:KeyAPI_TIME value:currentTime];
    NSArray *strings = [NSArray arrayWithObjects:APP_ID,currentTime,[@(_mainData.menu_id) stringValue],APP_SECRET,nil];
    [params put:KeyAPI_SIG value:[Utils getSigWithStrings:strings]];
    [params put:KeyAPI_MENU_ID value:[@(_mainData.menu_id) stringValue]];
    [params put:KeyAPI_PAGE_INDEX value:[@(_mainData.pageIndex) stringValue]];
    [params put:KeyAPI_PAGE_SIZE value:@"20"];
    [request execute:params withDelegate:self];
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

#pragma mark - TenpossCommunicatorDelegate
-(void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
    NSError *error = nil;
    if (errorCode != ERROR_OK) {
        NSString *errorDomain = [CommunicatorConst getErrorMessage:errorCode];
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
    }else{
        MenuItemResponse *data = (MenuItemResponse *)[responseParams get:KeyResponseObject];
        if (data.items && [data.items count] > 0) {
            _mainData.totalitem = data.total_items;
            for (ProductObject *item in data.items) {
                [_mainData addProduct:item];
                [_mainData increasePageIndex:1];
            }
        }else{
            error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_DETAIL_DATASOURCE_NO_CONTENT] code:ERROR_DETAIL_DATASOURCE_NO_CONTENT userInfo:nil];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
        [self.delegate dataLoaded:self withError:error];
    }
}

-(void)begin:(TenpossCommunicator*)request data:(Bundle*) responseParams{}

-( void)cancelAllRequest{}

@end
