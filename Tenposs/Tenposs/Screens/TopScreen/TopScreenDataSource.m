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
#import "TopScreen.h"
#import "AppConfiguration.h"
#import "TopCommunicator.h"
#import "Const.h"
#import "Utils.h"
#import "MenuCommunicator.h"


@interface TopScreenDataSource()<TenpossCommunicatorDelegate>

@property (strong, nonatomic)NSMutableArray *sectionArray;

@property (strong, nonatomic)NSMutableDictionary *unsortSectionArray;

@property (strong, nonatomic)NSMutableArray *currentRequests;

@end

@implementation TopScreenDataSource

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
    }else{
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
        if ([data isKindOfClass:[TopObject class]]) {
            return 1;
        }else{
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
    
    if ([item isKindOfClass:[ProductObject class]]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product class]) forIndexPath:indexPath];
    }else if([item isKindOfClass:[NSMutableArray<TopObject *> class]]){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Top class]) forIndexPath:indexPath];
    }else if([item isKindOfClass:[PhotoObject class]]){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Photo class]) forIndexPath:indexPath];
    }else if([item isKindOfClass:[ContactObject class]]){
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
            Top_Header *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Top_Header class]) forIndexPath:indexPath];
            [header configureHeaderWithTitle:[self sectionHeaderTitleForSection:indexPath.section]];
            reuseableView = header;
        }
    }else if(kind == UICollectionElementKindSectionFooter){
        if (![self sectionShouldHaveFooter:section]) {
            return nil;
        }else{
            Top_Footer *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([Top_Footer class]) forIndexPath:indexPath];
            NSObject *sectionData = [self sectionDataForSection:indexPath.section];
            NSObject *data = [(NSMutableArray *)sectionData firstObject];
            TopFooterTouchHandler handler = nil;
            
            if ([data isKindOfClass:[ProductObject class]]) {
                handler = ^{
                    NSLog(@"Top Footer is tapped!");
                    TopScreen *topScreen = (TopScreen *)self.delegate;
                    if (topScreen) {
                        [topScreen performNavigateToScreenWithId:APP_MENU_MENU];
                    }
                };
            }else if([data isKindOfClass:[NewsObject class]]){
                handler = ^{
                    NSLog(@"Top Footer is tapped!");
                    TopScreen *topScreen = (TopScreen *)self.delegate;
                    if (topScreen) {
                        [topScreen performNavigateToScreenWithId:APP_MENU_NEWS];
                    }
                };
            }else if ([data isKindOfClass:[PhotoObject class]]){
                handler = ^{
                    NSLog(@"Top Footer is tapped!");
                    TopScreen *topScreen = (TopScreen *)self.delegate;
                    if (topScreen) {
                        [topScreen performNavigateToScreenWithId:APP_MENU_PHOTO_GALLERY];
                    }
                };
            }
            
            [footer configureFooterWithTitle:@"もっと見る" withTouchHandler:handler];
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

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth{
    CGFloat width = 0;
    CGFloat height = 0;
    
    NSObject *item = [self dataAtIndexPath:indexPath];
    if([item isKindOfClass:[NSMutableArray<TopObject *> class]]){
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
    }else if([item isKindOfClass:[ContactObject class]]){
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

- (CGFloat)minimumLineSpacingForSection:(NSInteger)section{
    return 8;
}

- (CGFloat)minimumInteritemSpacingForSection:(NSInteger)section{
    return 8;
}

- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 8, 5, 8);
    }
    return UIEdgeInsetsMake(10, 8, 5, 8);
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
            }else if (top.top_id == APP_MENU_RESERVE){
                if(topData.contacts && [topData.contacts count] > 0){
                    NSMutableArray<ContactObject *> *contactArray = (NSMutableArray<ContactObject *> *)[[NSMutableArray alloc]init];
                    if ([topData.contacts count] >= 1)
                        [contactArray addObject:[topData.contacts objectAtIndex:0]];
                    [self.sectionArray addObject:contactArray];
                }
                continue;
            }else if (top.top_id == APP_MENU_IMAGES){
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
    
//        if (topData.images && [topData.images count]>0) {
//            NSMutableArray<TopObject *> *topArray = (NSMutableArray<TopObject *> *)[[NSMutableArray alloc]init];
//            for (TopObject *top in topData.images) {
//                [topArray addObject:top];
//            }
//            [self.sectionArray addObject:topArray];
//        }
//        if(topData.items && [topData.items count] > 0){
//            NSMutableArray<ProductObject *> *proArray = (NSMutableArray<ProductObject *> *)[[NSMutableArray alloc]init];
//            for (ProductObject *pro in topData.items) {
//                [proArray addObject:pro];
//            }
//            [self.sectionArray addObject:proArray];
//        }
//        if(topData.photos && [topData.photos count] > 0){
//            NSMutableArray<PhotoObject *> *phoArray = (NSMutableArray<PhotoObject *> *)[[NSMutableArray alloc]init];
//            for (PhotoObject *pro in topData.photos) {
//                [phoArray addObject:pro];
//            }
//            [self.sectionArray addObject:phoArray];
//        }
//        if(topData.news && [topData.news count] > 0){
//            NSMutableArray<NewsObject *> *newsArray = (NSMutableArray<NewsObject *> *)[[NSMutableArray alloc]init];
//            for (NewsObject *news in topData.news) {
//                [newsArray addObject:news];
//            }
//            [self.sectionArray addObject:newsArray];
//        }
//        if(topData.contacts && [topData.contacts count] > 0){
//            NSMutableArray<ContactObject *> *contactArray = (NSMutableArray<ContactObject *> *)[[NSMutableArray alloc]init];
//    //        for (ContactObject *contact in topData.contacts) {
//    //            [contactArray addObject:contact];
//    //        }
//            if ([topData.contacts count] >= 1)
//                [contactArray addObject:[topData.contacts objectAtIndex:0]];
//            [self.sectionArray addObject:contactArray];
//        }
//        topData = nil;
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
