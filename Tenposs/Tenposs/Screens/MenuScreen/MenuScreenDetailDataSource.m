//
//  MenuScreenDetailDataSource.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/9/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "MenuScreenDetailDataSource.h"
#import "Item_Cell_News.h"
#import "Item_Cell_Product.h"
#import "Utils.h"
#import "AppConfiguration.h"
#import "Item_Cell_Product_Item_t2.h"

#define SPACING_ITEM_PRODUCT 8

@interface MenuScreenDetailDataSource()

@end

@implementation MenuScreenDetailDataSource

- (instancetype)initWithMenuCategory:(MenuCategoryModel *)menuCategory{
    self = [super init];
    if (self) {
        self.mainData = menuCategory;
    }
    return self;
}

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate andMenuCategory:(MenuCategoryModel *)menuCategory{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.mainData = menuCategory;
    }
    return self;
}

-(void)reloadDataSource{
    [self cancelOldRequest];
//    self.cache = self.mainData.items;
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
    [params put:KeyAPI_PAGE_SIZE value:@"4"];
    
    [request execute:params withDelegate:self];
    [self.requestArray addObject:request];
}

- (void)registerClassForCollectionView:(UICollectionView *)collection{
    AppSettings *settings = [[AppConfiguration sharedInstance] getAvailableAppSettings];
    if(settings.template_id == 1){
        [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Product class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product class])];
    }else if (settings.template_id == 2){
        [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Product_Item_t2 class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product_Item_t2 class])];
    }
}

- (BOOL)isEqualTo:(SimpleDataSource *)second{
    if (![second isKindOfClass:[MenuScreenDetailDataSource class]]) {
        NSAssert(NO, @"DataSource type is not right!");
        return NO;
    }else{
        if (self.mainData.menu_id == ((MenuScreenDetailDataSource *)second).mainData.menu_id) {
            return YES;
        }else{
            return NO;
        }
    }
}

- (NSInteger)numberOfItem{
    return [self.mainData.items count];
}

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *item = nil;
    @try {
         item = [self.mainData.items objectAtIndex:indexPath.row];
    } @catch (NSException *exception) {
        NSLog(@"Error %@", exception.description);
    } @finally {
        
    }
    return item;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.mainData.items count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductObject *item = (ProductObject *)[self itemAtIndexPath:indexPath];
    
    Common_Item_Cell *cell = nil;
    
    AppSettings *settings = [[AppConfiguration sharedInstance] getAvailableAppSettings];
    if(settings.template_id == 1){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product class]) forIndexPath:indexPath];
    }else if (settings.template_id == 2){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product_Item_t2 class]) forIndexPath:indexPath];
    }
    
    if (cell && item) {
        [cell configureCellWithData:item];
    }
    return cell;
}

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth{
    
    CGFloat width = (superWidth - 3*SPACING_ITEM_PRODUCT) / 2;
    CGFloat height = 0;
    
    AppSettings *settings = [[AppConfiguration sharedInstance] getAvailableAppSettings];
    if(settings.template_id == 1){
      height = [Item_Cell_Product getCellHeightWithWidth:width];
    }else if (settings.template_id == 2){
     height = [Item_Cell_Product_Item_t2 getCellHeightWithWidth:width];
    }
    
    return CGSizeMake(width,height);
}

- (CGSize)sizeForHeaderAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}

- (CGSize)sizeForFooterAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}

-(UIEdgeInsets)insetForSection:(NSInteger)section{
    return UIEdgeInsetsMake(20, 8, 5, 8);
}

- (CGFloat)minimumLineSpacingForSection:(NSInteger)section{
    return 8;
}

- (CGFloat)minimumInteritemSpacingForSection:(NSInteger)section{
    return 8;
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
            }
        }else{
            if ([_mainData.items count] > 0) {
                error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_CONTENT_FULLY_LOADED] code:ERROR_CONTENT_FULLY_LOADED userInfo:nil];

            }else{
                error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_DETAIL_DATASOURCE_NO_CONTENT] code:ERROR_DETAIL_DATASOURCE_NO_CONTENT userInfo:nil];
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
        [self.delegate dataLoaded:self withError:error];
    }
    
    if([self.requestArray count] > 1){
        NSLog(@"GREATER THAN 2");
    }
    
    [self.requestArray removeObject:request];
    
    [_mainData increasePageIndex:1];

}

-(void)begin:(TenpossCommunicator*)request data:(Bundle*) responseParams{}

-( void)cancelAllRequest{}

@end
