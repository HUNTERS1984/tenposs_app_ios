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
#import "Item_Cell_Top.h"
#import "TenpossCommunicator.h"
#import "Top_Header.h"
#import "Top_Footer.h"
#import "Common_Item_Cell.h"
#import "MockupData.h"
#import "TopCommunicator.h"


@interface TopScreenDataSource()<TenpossCommunicatorDelegate>

@property (strong, nonatomic)NSMutableArray *sectionArray;

@property (strong, nonatomic)NSMutableDictionary *unsortSectionArray;

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

- (NSObject *)sectionDataForSection:(NSInteger)section{
    if (section >= [_sectionArray count]) {
        return nil;
    }
    NSMutableArray *sectionData = [_sectionArray objectAtIndex:section];
    return sectionData;
}

- (NSObject *)dataAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *sectionData = [self sectionDataForSection:indexPath.section];
    if (sectionData) {
        return [(NSMutableArray *)sectionData objectAtIndex:indexPath.row];
    }
    return nil;
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
    
    Common_Item_Cell *cell = nil;
    NSObject *item = [self dataAtIndexPath:indexPath];
    
    if ([item isKindOfClass:[ProductObject class]]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product class]) forIndexPath:indexPath];
    }else if([item isKindOfClass:[TopObject class]]){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Top class]) forIndexPath:indexPath];
    }else if([item isKindOfClass:[PhotoObject class]]){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Photo class]) forIndexPath:indexPath];
    }else if([item isKindOfClass:[ShopObject class]]){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_ShopInfo class]) forIndexPath:indexPath];
    }else if([item isKindOfClass:[NewsObject class]]){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_News class]) forIndexPath:indexPath];
    }
    
    [cell configureCellWithData:item];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.sectionArray count];// numberOfSection;
}

- (BOOL)sectionShouldHaveHeader:(NSInteger)section{
    NSObject *sectionData = [self sectionDataForSection:section];
    NSObject *data = [(NSMutableArray *)sectionData firstObject];
    if ([data isKindOfClass:[TopObject class]]) {
        return NO;
    }else if ([data isKindOfClass:[ProductObject class]]) {
        return YES;
    }else if ([data isKindOfClass:[PhotoObject class]]) {
        return YES;
    }else if ([data isKindOfClass:[NewsObject class]]) {
        return YES;
    }else if ([data isKindOfClass:[ShopObject class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)sectionShouldHaveFooter:(NSInteger)section{
    return YES;
}

-(NSString *)sectionHeaderTitleForSection:(NSInteger)section{
    NSObject *sectionData = [self sectionDataForSection:section];
    NSObject *data = [(NSMutableArray *)sectionData firstObject];
    if ([data isKindOfClass:[ProductObject class]]) {
        return @"Products";
    }else if ([data isKindOfClass:[PhotoObject class]]) {
        return @"Gallery";
    }else if ([data isKindOfClass:[NewsObject class]]) {
        return @"News";
    }else if ([data isKindOfClass:[ShopObject class]]) {
        return @"Shop";
    }
    return @"";
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reuseableView = nil;
    NSInteger section = indexPath.section;
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (![self sectionShouldHaveHeader:section]) {
            return nil;
        }else{
            Top_Header *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Top_Header class]) forIndexPath:indexPath];
            [header configureHeaderWithTitle:[self sectionHeaderTitleForSection:indexPath.section]];
            reuseableView = header;
        }
    }else if(kind == UICollectionElementKindSectionFooter){
        if (![self sectionShouldHaveFooter:section]) {
            return nil;
        }else{
            Top_Footer *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([Top_Footer class]) forIndexPath:indexPath];
            [footer configureFooterWithTitle:@"View More" withTouchHandler:^{
                
            }];
            reuseableView = footer;
        }
    }
    
    return reuseableView;
}

#pragma mark - Public Methods

- (void)registerClassForCollectionView:(UICollectionView *)collection{
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Top class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Top class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Product class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_News class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_News class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Photo class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Photo class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_ShopInfo class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_ShopInfo class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Top_Header class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Top_Header class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Top_Footer class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([Top_Footer class])];
}

- (void)fetchContent{
    [self loadTopData];
}

- (CellSpanType)cellSpanTypeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *item = [self dataAtIndexPath:indexPath];
    if ([item isKindOfClass:[ProductObject class]]) {
        return [Item_Cell_Product getCellSpanType];
    }else if([item isKindOfClass:[TopObject class]]){
        return CellSpanTypeFull;
    }else if([item isKindOfClass:[PhotoObject class]]){
        return [Item_Cell_Photo getCellSpanType];
    }else if([item isKindOfClass:[ShopObject class]]){
        return [Item_Cell_ShopInfo getCellSpanType];
    }
    return CellSpanTypeNone;
}

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth{
    CGFloat width = 0;
    CGFloat height = 0;
    
    NSObject *item = [self dataAtIndexPath:indexPath];
    if([item isKindOfClass:[TopObject class]]){
        width = superWidth;
        height = [Item_Cell_Top getCellHeightWithWidth:width];
    }else if ([item isKindOfClass:[ProductObject class]]) {
        width = (superWidth - 3*SPACING_ITEM_PRODUCT) / 2;
        height = [Item_Cell_Product getCellHeightWithWidth:width];
    }else if([item isKindOfClass:[TopObject class]]){
        width = superWidth;
        height = superWidth / 2;
    }else if([item isKindOfClass:[PhotoObject class]]){
        width = (superWidth - 4*SPACING_ITEM_PHOTO)/3;
        height = [Item_Cell_Photo getCellHeightWithWidth:width];
    }else if([item isKindOfClass:[ShopObject class]]){
        width = superWidth;
        height = [Item_Cell_ShopInfo getCellHeightWithWidth:width];
    }else if([item isKindOfClass:[NewsObject class]]){
        width = superWidth;
        height = [Item_Cell_News getCellHeightWithWidth:width];
    }
    CGSize cellSize = CGSizeMake(width, height);
    NSLog(@"TOP_CELL_SIZE: %@", NSStringFromCGSize(cellSize));
    return cellSize;
}

-(CGSize)sizeForHeaderAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    if (![self sectionShouldHaveHeader:section]) {
        return CGSizeZero;
    }else{
        return CGSizeMake(collectionView.bounds.size.width, [Top_Header height]);
    }
}

-(CGSize)sizeForFooterAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    if (![self sectionShouldHaveFooter:section]) {
        return CGSizeZero;
    }else{
        return CGSizeMake(collectionView.bounds.size.width, [Top_Footer height]);
    }
}

#pragma mark - Communication

- (void)loadTopData{
    NSData *data = [MockupData fetchDataWithResourceName:@"top_data"];
    NSError *error;
    TopDataModel *topData = [[TopDataModel alloc] initWithData:data error:&error];
    [self loadDataIntoSectionArray:topData];
    if (!error) {
        if (topData) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(dataLoadedWithError:)]){
                [self.delegate dataLoadedWithError:nil];
            }
        }
    }
}

- (void)loadDataIntoSectionArray:(TopDataModel *)topData{
    if (!self.sectionArray) {
        self.sectionArray = [[NSMutableArray alloc] init];
    }
    if (topData.images && [topData.images count]>0) {
        NSMutableArray<TopObject *> *topArray = (NSMutableArray<TopObject *> *)[[NSMutableArray alloc]init];
        for (TopObject *top in topData.images) {
            [topArray addObject:top];
        }
        [self.sectionArray addObject:topArray];
    }
    if(topData.items && [topData.items count] > 0){
        NSMutableArray<ProductObject *> *proArray = (NSMutableArray<ProductObject *> *)[[NSMutableArray alloc]init];
        for (ProductObject *pro in topData.items) {
            [proArray addObject:pro];
        }
        [self.sectionArray addObject:proArray];
    }
    if(topData.photos && [topData.photos count] > 0){
        NSMutableArray<PhotoObject *> *phoArray = (NSMutableArray<PhotoObject *> *)[[NSMutableArray alloc]init];
        for (PhotoObject *pro in topData.photos) {
            [phoArray addObject:pro];
        }
        [self.sectionArray addObject:phoArray];
    }
    if(topData.news && [topData.news count] > 0){
        NSMutableArray<NewsObject *> *newsArray = (NSMutableArray<NewsObject *> *)[[NSMutableArray alloc]init];
        for (NewsObject *news in topData.news) {
            [newsArray addObject:news];
        }
        [self.sectionArray addObject:newsArray];
    }
    topData = nil;
}

#pragma mark - TenpossCommunicatorDelegate

- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
    if (errorCode != 0) {
        
    }else{
        NSObject *data = [responseParams get:KeyResponseObject];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(dataLoadedWithError:)]){
        [self.delegate dataLoadedWithError:nil];
    }
}

- (void)begin:(TenpossCommunicator*)request data:(Bundle*) responseParams{

}

-( void)cancelAllRequest{

}


@end
