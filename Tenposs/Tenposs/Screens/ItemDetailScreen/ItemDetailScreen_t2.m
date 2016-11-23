//
//  ItemDetailScreen_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/9/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "ItemDetailScreen_t2.h"

#import "ItemDetailCommunicator.h"

#import "Item_Detail_ItemName_t2.h"
#import "Item_Cell_Product_Item_t2.h"
#import "Item_Detail_TopImage.h"
#import "Item_Detail_Description.h"
#import "Center_Text_Header.h"
#import "Left_Text_Header.h"
#import "Left_Text_Footer.h"
#import "Center_Text_Footer.h"

#import "TopScreenDataSource.h"

#import "UIViewController+LoadingView.h"
#import "UIFont+Themify.h"
#import "HexColors.h"
#import "AppConfiguration.h"
#import "UIUtils.h"
#import "UIButton+HandleBlock.h"
#import "Item_Detail_Item_Size.h"
#import "ItemDetailCommunicator.h"
#import "Utils.h"
#import "ItemRelatedCommunicator.h"
#import "UIFont+Themify.h"


@interface ItemDetailScreen_t2 ()

@property DescriptionCellInfo *descriptionData;

@end

@implementation ItemDetailScreen_t2

- (instancetype)initWithItem:(ProductObject *)item{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _item = item;
        if(!_descriptionData){
            NSString *fullText = _item.desc;
            if (!fullText) {
                fullText = @"データなし";
            }else{
                if([fullText isEqualToString:@""]){
                    fullText = @"データなし";
                }
            }
            _descriptionData = [[DescriptionCellInfo alloc] initWithFullText:fullText];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    if ([[self.navigationController viewControllers] count] > 1) {
        AppConfiguration *appConfig = [AppConfiguration sharedInstance];
        AppSettings *settings = [appConfig getAvailableAppSettings];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(didPressBackButton)];
        self.navigationItem.leftBarButtonItem = backButton;
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.navigationItem setBackBarButtonItem:nil];
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                       [UIFont themifyFontOfSize:20/*[UIUtils getTextSizeWithType:settings.font_size]*/], NSFontAttributeName,
                                                                       [UIColor colorWithHexString:settings.title_color], NSForegroundColorAttributeName,
                                                                       nil]
                                                             forState:UIControlStateNormal];
        [self.navigationItem.leftBarButtonItem setTitle:[NSString stringWithFormat: [UIFont stringForThemifyIdentifier:@"ti-angle-left"]]];
    }
    
    [self showLoadingViewWithMessage:@""];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Detail_TopImage class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Detail_TopImage class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Detail_ItemName_t2 class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Detail_ItemName_t2 class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Detail_Description class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Detail_Description class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Product_Item_t2 class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product_Item_t2 class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Detail_Item_Size class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Detail_Item_Size class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Left_Text_Header class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Left_Text_Header class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Center_Text_Header class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Center_Text_Header class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Left_Text_Footer class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([Left_Text_Footer class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Center_Text_Footer class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([Center_Text_Footer class])];
    
    [self getItemDetail];

}

- (NSString *)title{
    return _item.title;
}

- (void)didPressBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)getItemDetail{
    
    ItemDetailCommunicator *request = [ItemDetailCommunicator new];
    Bundle *params = [Bundle new];
    [params put:KeyAPI_APP_ID value:APP_ID];
    [params put:KeyAPI_ITEM_ID value:[@(_item.product_id) stringValue]];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    [params put:KeyAPI_TIME value:currentTime];
    NSArray *strings = [NSArray arrayWithObjects:APP_ID,currentTime,[@(_item.product_id) stringValue],APP_SECRET,nil];
    [params put:KeyAPI_SIG value:[Utils getSigWithStrings:strings]];
    [request execute:params withDelegate:self];
}

- (void)getItemRelated{
    ///TODO: clean mockup
    ItemRelatedCommunicator *request = [ItemRelatedCommunicator new];
    Bundle *params = [Bundle new];
    [params put:KeyAPI_APP_ID value:APP_ID];
    [params put:KeyAPI_ITEM_ID value:@"2"];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    [params put:KeyAPI_TIME value:currentTime];
    [params put:KeyAPI_PAGE_INDEX value:[@(_item.rel_pageindex) stringValue]];
    [params put:KeyAPI_PAGE_SIZE value:@"4"];
    NSArray *strings = [NSArray arrayWithObjects:APP_ID,currentTime,@"2",APP_SECRET,nil];
    [params put:KeyAPI_SIG value:[Utils getSigWithStrings:strings]];
    [request execute:params withDelegate:self];
}


- (void)handleRequestError:(NSError *)error{
    //TODO: show Error screen
}

- (void)previewData{
    if(!_descriptionData){
        _descriptionData = [[DescriptionCellInfo alloc] initWithFullText:_item.desc];
        [_descriptionData calculateFullTextHeightWithWidth:(self.collectionView.bounds.size.width - 16)];
    }
    [self.collectionView reloadData];
    [self removeLoadingView];
    
}

#pragma mark - UICollectionViewDataSource

-(BOOL)sectionShouldHaveHeader:(NSInteger)section{
    if (section == 0 || section == 1) {
        return NO;
    }else if (section == 3){
        if ([self hasRelatedItems]) {
            return YES;
        }else return NO;
    }
    return YES;
}

-(BOOL)sectionShouldHaveFooter:(NSInteger)section{
    if (section == 3){
        if (_item.rel_items && [_item.rel_items count] > 0 && [_item.rel_items count] < _item.total_items_related) {
            return YES;
        }else{
            return NO;
        }
    }else if (section == 2) {
            if (_descriptionData.fullSizeHeight <= DETAIL_DESCRIPTION_COLLAPSE) {
                return NO;
            }
            return YES;
    }
    return NO;
}

- (BOOL)hasRelatedItems{
    return _item.rel_items && [_item.rel_items count] > 0;
}

- (NSObject *)dataForIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:{
            return _item.image_url;
        }
        case 1:{
            return _item;
        }
        case 2:{
            if (!_item.description) {
                _descriptionData.fullText = @"データなし";
            }else{
                if ([_item.description isEqualToString:@""]) {
                    _descriptionData.fullText = @"データなし";
                }
            }
            return _descriptionData;//_item.desc;
        }
        case 3:{
            if ([self hasRelatedItems]) {
                return [_item.rel_items objectAtIndex:indexPath.row];
            }
            return nil;
        }
        default:
            return nil;
            break;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self hasRelatedItems]?4:3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        case 1:
        case 2:
            return 1;
        case 3:{
            if ([self hasRelatedItems]) {
                return [_item.rel_items count];
            }else return 0;
        }
        default:
            return 0;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Common_Item_Cell *cell = nil;
    NSObject *data = [self dataForIndexPath:indexPath];
    NSInteger section = indexPath.section;
    
    switch (section) {
        case 0:{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Detail_TopImage class]) forIndexPath:indexPath];
        }
            break;
        case 1:{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Detail_ItemName_t2 class]) forIndexPath:indexPath];
        }
            break;
        case 2:{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Detail_Description class]) forIndexPath:indexPath];
            [((Item_Detail_Description *)cell) configureCellWithData:data WithWidth:self.collectionView.bounds.size.width - 12];
            return cell;
        }
            break;
        case 3:{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product_Item_t2 class]) forIndexPath:indexPath];
        }
            break;
        default:
            break;
    }
    [cell configureCellWithData:data];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reuseableView = nil;
    NSInteger section = indexPath.section;
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (![self sectionShouldHaveHeader:section]) {
            return nil;
        }else{
            switch (section) {
                case 2:{
                    Left_Text_Header *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Left_Text_Header class]) forIndexPath:indexPath];
                    [((Left_Text_Header *)header).title setText:@"商品詳細"];
                    reuseableView = header;
                }
                    break;
                case 3:{
                    if ([self hasRelatedItems]) {
                        Left_Text_Header *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Left_Text_Header class]) forIndexPath:indexPath];
                        [((Left_Text_Header *)header).title setText:@"ゆかり"];
                        reuseableView = header;
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }else if(kind == UICollectionElementKindSectionFooter){
        if (![self sectionShouldHaveFooter:section]) {
            return nil;
        }else{
            switch (section) {
                case 2:{
                    Left_Text_Footer *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([Left_Text_Header class]) forIndexPath:indexPath];
                    
                    __weak ItemDetailScreen_t2 *weakSelf = self;
                    __weak DescriptionCellInfo *weakCellInfo = _descriptionData;
                    [((Left_Text_Footer *)footer).footerButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                        weakCellInfo.isCollapsed = !weakCellInfo.isCollapsed;
                        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
                    }];
                    if(_descriptionData.isCollapsed){
                        [((Left_Text_Footer *)footer).title setText:@"もっと見る"];
                    }else{
                        //TODO: need localize
                        [((Left_Text_Footer *)footer).title setText:@"show less"];
                    }
                    [((Left_Text_Footer *)footer).title setTextColor:[UIColor colorWithHexString:@"3CB963"]];
                    reuseableView = footer;
                    break;
                }
                case 3:{
                    if ([self hasRelatedItems]) {
                        Center_Text_Footer *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([Center_Text_Footer class]) forIndexPath:indexPath];
                        [((Center_Text_Footer *)footer).title setText:@"もっと見る"];
                        
                        __weak ItemDetailScreen_t2 *weakSelf = self;
                        [((Center_Text_Footer *)footer).footerButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                            [weakSelf getItemRelated];
                        }];
                        reuseableView = footer;
                        break;
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }
    return reuseableView;
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat superWidth = collectionView.bounds.size.width;
    
    switch (section) {
        case 0:{
            width = superWidth;
            height = superWidth/2;
        }
            break;
        case 1:{
            width = superWidth;
            height = [Item_Detail_ItemName_t2 getCellHeightWithWidth:width];
        }
            break;
        case 2:{
            width = superWidth;
            if (_descriptionData.isCollapsed) {
                height = DETAIL_DESCRIPTION_COLLAPSE;
            }else{
                height = _descriptionData.fullSizeHeight >= 10?_descriptionData.fullSizeHeight:DETAIL_DESCRIPTION_COLLAPSE;
            }
        }
            break;
        case 3:{
            width = (superWidth - 3*SPACING_ITEM_PRODUCT) / 2;
            height = [Item_Cell_Product_Item_t2 getCellHeightWithWidth:width];
        }
            break;
        default:
            break;
    }
    
    return CGSizeMake(width, height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat top = 0;
    CGFloat left = 0;
    CGFloat bottom = 0;
    CGFloat right = 0;
    
//    switch (section) {
//        case 0:
//            break;
//        case 1:
//            bottom = 8;
//            break;
//        case 2:
//            bottom = 8;
//            break;
//        case 3:
//            bottom = 8;
//        default:
//            break;
//    }
    if(section == 3){
        return UIEdgeInsetsMake(0, 8, 5, 8);
    }
    
    return UIEdgeInsetsMake(0, 0, 5, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 3) {
        return 8;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 3) {
        return 8;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (![self sectionShouldHaveHeader:section]) {
        return CGSizeZero;
    }else{
        return CGSizeMake(collectionView.bounds.size.width, 44);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (![self sectionShouldHaveFooter:section]) {
        return CGSizeZero;
    }else{
        return CGSizeMake(collectionView.bounds.size.width, 44);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *data = [self dataForIndexPath:indexPath];
    if ([data isKindOfClass:[ProductObject class]]) {
        ProductObject *product = (ProductObject *)data;
        ItemDetailScreen_t2 *controller = [[ItemDetailScreen_t2 alloc] initWithItem:product];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - TenpossCommunicatorDelegate

- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
    NSError *error = nil;
    if (errorCode != ERROR_OK) {
        NSString *errorDomain = [responseParams get:KeyResponseError];
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
        
        if ([request isKindOfClass:[ItemDetailCommunicator class]]) {
            [self showErrorScreen:@"Error, something went wrong! Please try again." andRetryButton:^{
                [self getItemDetail];
            }];
            return;
        }else if ([request isKindOfClass:[ItemRelatedCommunicator class]]){
            [self previewData];
        }
        
        
    }else{
        if ([request isKindOfClass:[ItemDetailCommunicator class]]) {
            ItemDetailResponse *itemDetail = (ItemDetailResponse *)[responseParams get:KeyResponseObject];
            if (itemDetail) {
                if (itemDetail.detail) {
                    [_item updateItemWithItem:itemDetail.detail];
                }
                if (itemDetail.items_related && [itemDetail.items_related count] > 0) {
                    [_item.rel_items removeAllObjects];
                    [_item.rel_items addObjectsFromArray:itemDetail.items_related];
                }
                if (itemDetail.total_items_related) {
                    _item.total_items_related = itemDetail.total_items_related;
                }
            }
            [self getItemRelated];
        }else if ([request isKindOfClass:[ItemRelatedCommunicator class]]){
            ItemRelatedResponse *itemRelated = (ItemRelatedResponse *)[responseParams get:KeyResponseObject];
            if (itemRelated) {
                if (itemRelated.items && [itemRelated.items count] > 0) {
                    for(ProductObject *item in itemRelated.items){
                        [_item addRelatedItem:item];
                    }
                    _item.rel_pageindex += 1;
                }
                if (itemRelated.total_items) {
                    _item.total_items_related = itemRelated.total_items;
                }
            }
            [self previewData];
        }
    }
}

- (void)begin:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    
}

-( void)cancelAllRequest{
    
}


@end
