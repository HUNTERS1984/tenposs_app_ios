//
//  TopScreenDataSource_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TopScreenDataSource_t2.h"
#import "TopCommunicator.h"
#import "Common_Item_Cell.h"
#import "Item_Cell_Top_t2.h"
#import "Item_Cell_Product_t2.h"
#import "Item_Cell_News_t2.h"
#import "Item_Cell_Photo_t2.h"
#import "Top_Header_t2.h"
#import "TopScreen.h"
#import "UIButton+HandleBlock.h"

#import "Utils.h"

@interface TopScreenDataSource_t2()

@property (strong, nonatomic)NSMutableArray *sectionArray;

@property (strong, nonatomic)NSMutableDictionary *unsortSectionArray;

@property (strong, nonatomic)NSMutableArray *currentRequests;

@end

@implementation TopScreenDataSource_t2

- (NSObject *)sectionDataForSection:(NSInteger)section{
    if (section >= [_sectionArray count]) {
        return nil;
    }
    NSMutableArray *sectionData = [_sectionArray objectAtIndex:section];
    return sectionData;
}

- (NSObject *)dataAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *sectionData = [self sectionDataForSection:indexPath.section];
    NSObject *data = [(NSMutableArray *)sectionData firstObject];
    if ([data isKindOfClass:[TopObject class]]) {
        return sectionData;
    }else if ([data isKindOfClass:[ProductObject class]]){
        return sectionData;
    }else if ([data isKindOfClass:[PhotoObject class]]){
        return sectionData;
    }else if([data isKindOfClass:[NewsObject class]]){
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
        NSObject *data = [(NSMutableArray *)sectionData firstObject];
        if ([data isKindOfClass:[TopObject class]]
            || [data isKindOfClass:[ProductObject class]]
            || [data isKindOfClass:[PhotoObject class]]){
            return 1;
        }else if ([data isKindOfClass:[NewsObject class]]){
            return [sectionData count];
        }
    }else{
        NSAssert(false, @"Wrong section index or sectionArray doesn't contain this section");
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Common_Item_Cell *cell = nil;
    NSObject *item = [self dataAtIndexPath:indexPath];
    
    if ([item isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *array = (NSMutableArray *)item;
        NSObject *obj = [array firstObject];
        if ([obj isKindOfClass:[ProductObject class]]) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product_t2 class]) forIndexPath:indexPath];
            [((Item_Cell_Product_t2 *)cell) configureCellWithData:item productSelectHandler:^(ProductObject *p) {
                TopScreen *topScreen = (TopScreen *)self.delegate;
                if (topScreen) {
                    [topScreen handleItemTouched:p];
                }
            } andHeaderSelectHandler:^(NSInteger headerScreenId) {
                TopScreen *topScreen = (TopScreen *)self.delegate;
                if (topScreen) {
                    [topScreen performNavigateToScreenWithId:APP_MENU_MENU];
                }
            }];
            return cell;
        }else if([obj isKindOfClass:[TopObject class]]){
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Top_t2 class]) forIndexPath:indexPath];
            [cell layoutIfNeeded];
        }else if([obj isKindOfClass:[PhotoObject class]]){
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Photo_t2 class]) forIndexPath:indexPath];
            [((Item_Cell_Photo_t2 *)cell) configureCellWithData:item photoSelectHandler:^(PhotoObject *p) {
                TopScreen *topScreen = (TopScreen *)self.delegate;
                if (topScreen) {
                    [topScreen handleItemTouched:p];
                }
            } andHeaderSelectHandler:^(NSInteger headerScreenId) {
                TopScreen *topScreen = (TopScreen *)self.delegate;
                if (topScreen) {
                    [topScreen performNavigateToScreenWithId:APP_MENU_PHOTO_GALLERY];
                }
            }];
            return cell;
        }
    }else if([item isKindOfClass:[NewsObject class]]){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_News_t2 class]) forIndexPath:indexPath];
    }
    
    [cell configureCellWithData:item];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger numberOfSection = [self.sectionArray count];
    return numberOfSection;// numberOfSection;
}

- (BOOL)sectionShouldHaveHeader:(NSInteger)section{
    NSObject *sectionData = [self sectionDataForSection:section];
    NSObject *data = [(NSMutableArray *)sectionData firstObject];
    if ([data isKindOfClass:[TopObject class]]) {
        return NO;
    }else if ([data isKindOfClass:[ProductObject class]]) {
        return NO;
    }else if ([data isKindOfClass:[PhotoObject class]]) {
        return NO;
    }else if ([data isKindOfClass:[NewsObject class]]) {
        return YES;
    }else if ([data isKindOfClass:[ContactObject class]]) {
        return NO;
    }
    return NO;
}

- (BOOL)sectionShouldHaveFooter:(NSInteger)section{
    NSObject *sectionData = [self sectionDataForSection:section];
    NSObject *data = [(NSMutableArray *)sectionData firstObject];
    if ([data isKindOfClass:[TopObject class]]||[data isKindOfClass:[ContactObject class]]) {
        return NO;
    }
    return YES;
}

-(NSString *)sectionHeaderTitleForSection:(NSInteger)section{
    NSObject *sectionData = [self sectionDataForSection:section];
    NSObject *data = [(NSMutableArray *)sectionData firstObject];
    if ([data isKindOfClass:[ProductObject class]]) {
        return @"最近";
    }else if ([data isKindOfClass:[PhotoObject class]]) {
        return @"フォトギャラリー";
    }else if ([data isKindOfClass:[NewsObject class]]) {
        return @"ニュース";
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
            Top_Header_t2 *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Top_Header_t2 class]) forIndexPath:indexPath];
            [((Top_Header_t2 *)header) configureHeaderWithMenuId:APP_MENU_NEWS];
            [((Top_Header_t2 *)header).headerButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                TopScreen *topScreen = (TopScreen *)self.delegate;
                if (topScreen) {
                    [topScreen performNavigateToScreenWithId:APP_MENU_NEWS];
                }
            }];
            reuseableView = header;
        }
    }
    return reuseableView;
}

#pragma mark - Public Methods

- (void)registerClassForCollectionView:(UICollectionView *)collection{
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Top_t2 class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Top_t2 class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Product_t2 class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product_t2 class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_News_t2 class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_News_t2 class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Photo_t2 class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Photo_t2 class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Top_Header_t2 class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Top_Header_t2 class])];
}

- (void)fetchContent{
    [self loadTopData];
}

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth{
    CGFloat width = superWidth;
    CGFloat height = 0;
    NSObject *item = [self dataAtIndexPath:indexPath];
    if ([item isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *array = (NSMutableArray *)item;
        NSObject *obj = [array firstObject];
        if ([obj isKindOfClass:[TopObject class]]) {
            CGSize size = CGSizeMake(superWidth, [Item_Cell_Top_t2 getCellHeightWithWidth:superWidth]);
            return size;
        }else if ([obj isKindOfClass:[ProductObject class]]) {
            height =[Item_Cell_Product_t2 getCellHeightWithWidth:width];
        }else if ([obj isKindOfClass:[PhotoObject class]]){
            height = [Item_Cell_Photo_t2 getCellHeightWithWidth:width];
        }
    }else if([item isKindOfClass:[NewsObject class]]){
        return CGSizeMake(superWidth, [Item_Cell_News_t2 getCellHeightWithWidth:superWidth]);
    }
    CGSize cellSize = CGSizeMake(width, height);
    NSLog(@"TOP_CELL_SIZE: %@", NSStringFromCGSize(cellSize));
    return cellSize;
}

-(CGSize)sizeForHeaderAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    if (![self sectionShouldHaveHeader:section]) {
        return CGSizeZero;
    }else{
        return CGSizeMake(collectionView.bounds.size.width, 44);
    }
}

-(CGSize)sizeForFooterAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
//    if (![self sectionShouldHaveFooter:section]) {
        return CGSizeZero;
//    }else{
//        return CGSizeMake(collectionView.bounds.size.width, [Top_Footer height]);
//    }
}

- (CGFloat)minimumLineSpacingForSection:(NSInteger)section{
    return 0;
}

- (CGFloat)minimumInteritemSpacingForSection:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 8, 0);
    }
    return UIEdgeInsetsMake(0, 0, 8, 0);
}


#pragma mark - Communication

- (void)loadTopData{
    TopCommunicator *request = [TopCommunicator new];
    Bundle *params = [Bundle new];
    [params put:KeyAPI_APP_ID value:APP_ID];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    [params put:KeyAPI_TIME value:currentTime];
    NSArray *strings = [NSArray arrayWithObjects:APP_ID,currentTime,APP_SECRET,nil];
    [params put:KeyAPI_SIG value:[Utils getSigWithStrings:strings]];
    [request execute:params withDelegate:self];
}

- (void)loadDataIntoSectionArray:(TopResponse *)topData{
    if (!self.sectionArray) {
        self.sectionArray = [[NSMutableArray alloc] init];
    }
    NSArray *topComponents = [[AppConfiguration sharedInstance] getAvailableTopComponents];
    
    if (topComponents && [topComponents count] > 0) {
        for (TopComponentModel *top in topComponents) {
            if (top.top_id == APP_MENU_MENU) {
                if(topData.items && [topData.items count] > 0){
                    NSMutableArray<ProductObject *> *proArray = (NSMutableArray<ProductObject *> *)[[NSMutableArray alloc]init];
                    for (ProductObject *pro in topData.items) {
                        [proArray addObject:pro];
                    }
                    [self.sectionArray addObject:proArray];
                    
                }
                continue;
            }else if(top.top_id == APP_MENU_NEWS){
                if(topData.news && [topData.news count] > 0){
                    
                    NSMutableArray<TopObject *> *topArray = (NSMutableArray<TopObject *> *)[[NSMutableArray alloc]init];
                    for (TopObject *top in topData.news) {
                        [topArray addObject:top];
                    }
                    [self.sectionArray addObject:topArray];
                    
                }
                continue;
            }else if (top.top_id == APP_MENU_PHOTO_GALLERY){
                if(topData.photos && [topData.photos count] > 0){
                    
                    NSMutableArray<PhotoObject *> *phoArray = (NSMutableArray<PhotoObject *> *)[[NSMutableArray alloc]init];
                    for (PhotoObject *pro in topData.photos) {
                        [phoArray addObject:pro];
                    }
                    [self.sectionArray addObject:phoArray];
                }
                continue;
            }
//            else if (top.top_id == APP_MENU_RESERVE){
//                if(topData.contacts && [topData.contacts count] > 0){
//                    NSMutableArray<ContactObject *> *contactArray = (NSMutableArray<ContactObject *> *)[[NSMutableArray alloc]init];
//                    if ([topData.contacts count] >= 1)
//                        [contactArray addObject:[topData.contacts objectAtIndex:0]];
//                    [self.sectionArray addObject:contactArray];
//                }
//                continue;
//            }
            else if (top.top_id == APP_MENU_IMAGES){
                if(topData.images && [topData.images count] > 0){
                    NSMutableArray<TopObject *> *topArray = (NSMutableArray<TopObject *> *)[[NSMutableArray alloc]init];
                    for (TopObject *top in topData.images) {
                        [topArray addObject:top];
                    }
                    [self.sectionArray addObject:topArray];
                }
                continue;
            }
        }
    }
    
}

#pragma mark - TenpossCommunicatorDelegate

- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
    NSError *error = nil;
    if (errorCode != ERROR_OK) {
        NSString *errorDomain = [responseParams get:KeyResponseError];
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
    }else{
        TopResponse *data = (TopResponse *)[responseParams get:KeyResponseObject];
        [self loadDataIntoSectionArray:data];
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
