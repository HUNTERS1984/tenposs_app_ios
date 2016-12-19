//
//  ItemDetailScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/23/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "ItemDetailScreen.h"
#import "ItemDetailCommunicator.h"
#import "Item_Detail_ItemName.h"
#import "Item_Detail_TopImage.h"
#import "Item_Detail_Description.h"
#import "Item_Detail_Header_Segmented.h"
#import "Top_Header.h"
#import "Top_Footer.h"
#import "Item_Cell_Product.h"
#import "TopScreenDataSource.h"
#import "Common_Item_Cell.h"
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

@interface ItemDetailScreen ()<SFSafariViewControllerDelegate>{
    Item_Detail_Header_Segmented *segmentCell;
}

@property DescriptionCellInfo *descriptionData;

@property NSInteger currentSwitchIndex;

@end

@implementation ItemDetailScreen

- (instancetype)initWithItem:(ProductObject *)item{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _item = item;
        _currentSwitchIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getItemDetail];
    
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
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Detail_ItemName class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Detail_ItemName class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Detail_Header_Segmented class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Detail_Header_Segmented class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Detail_Description class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Detail_Description class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Product class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Detail_Item_Size class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Detail_Item_Size class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Top_Header class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Top_Header class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Top_Footer class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([Top_Footer class])];
    
    
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
    [params put:KeyAPI_ITEM_ID value:[@(_item.product_id) stringValue]];
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
    if (section == 2) {
        return YES;
    }
    return NO;
}

-(BOOL)sectionShouldHaveFooter:(NSInteger)section{
    if (section == 2){
        if (_item.rel_items && [_item.rel_items count] > 0 && [_item.rel_items count] < _item.total_items_related) {
            return YES;
        }else{
            return NO;
        }
    }else if (section == 1) {
        if (_currentSwitchIndex == 0) {
            if (_descriptionData.fullSizeHeight <= DETAIL_DESCRIPTION_COLLAPSE) {
                return NO;
            }
            return YES;
        }else{
            return NO;
        }
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
            break;
        case 1:{
            NSInteger index = indexPath.row;
            if (index == 0) {
                return _item;
            }else if (index == 1){
                return _item;
            }else{
                if (_currentSwitchIndex == 0) {
                    if (!_descriptionData) {
                        _descriptionData = [[DescriptionCellInfo alloc]initWithFullText:_item.desc];
                    }
                    return _descriptionData;//_item.desc;
                }else{
                    if (!_item.size || [_item.size count] <= 0) {
                        DescriptionCellInfo *noSize = [[DescriptionCellInfo alloc]initWithFullText:@"データなし"];
                        [noSize calculateFullTextHeightWithWidth:self.view.bounds.size.width];
                        return noSize;
                    }else{
                        NSInteger realIndex = index - 2;
                        if (realIndex < 0) {
                            realIndex = 0;
                        }
                        NSMutableArray *sizes = [_item getSizeArray];
                        if (sizes && [sizes count] > realIndex) {
                            return [sizes objectAtIndex:realIndex];
                        }
//                        else{
//                            _descriptionData = [[DescriptionCellInfo alloc]initWithFullText:_item.desc];
//                            return _descriptionData;//_item.desc;
//                        }
                    }
                }
            }
        }
            break;
        case 2:{
            if ([self hasRelatedItems]) {
                return [_item.rel_items objectAtIndex:indexPath.row];
            }
            return nil;
        }
            break;
        default:
            return nil;
            break;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self hasRelatedItems]?3:2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            if (_currentSwitchIndex == 0) {
                return 3;
            }else{
                if (!_item.size || [_item.size count] <= 0) {
                    return 3;
                }else{
                    NSMutableArray *sizes = [_item getSizeArray];
                    return 2 + [sizes count];
                }
            }
            break;
        case 2:{
            if ([self hasRelatedItems]) {
                return [_item.rel_items count];
            }else return 0;
        }
            break;
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
            NSInteger index = indexPath.row;
            if (index == 0) {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Detail_ItemName class]) forIndexPath:indexPath];
                if ([data isKindOfClass:[ProductObject class]]) {
                    ProductObject *p = (ProductObject *)data;
                    
                    if (p.item_link && ![p.item_link isEqualToString:@""]) {
                        NSURL *url = [NSURL URLWithString:p.item_link];
                        [((Item_Detail_ItemName *)cell).purchaseButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                            if ([SFSafariViewController class] != nil) {
                                SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:url];
                                sfvc.delegate = self;
                                [self presentViewController:sfvc animated:YES completion:nil];
                            } else {
                                if (![[UIApplication sharedApplication] openURL:url]) {
                                    NSLog(@"Failed to open url: %@",[url description]);
                                }
                            }
                        }];
                    }
                }
            }else if (index == 1){
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Detail_Header_Segmented class]) forIndexPath:indexPath];
                [cell configureCellWithData:data];
                [((Item_Detail_Header_Segmented *)cell).segmentControl addTarget:self action:@selector(onHeaderSegmentedChange:) forControlEvents:UIControlEventValueChanged];
                [((Item_Detail_Header_Segmented *)cell).segmentControl setSelectedIndex:_currentSwitchIndex];
                return cell;
            }else if([data isKindOfClass:[DescriptionCellInfo class]]){
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Detail_Description class]) forIndexPath:indexPath];
                [((Item_Detail_Description *)cell) configureCellWithData:data WithWidth:self.collectionView.bounds.size.width - 16];
                return cell;
            }else if ([data isKindOfClass:[NSString class]] || [data isKindOfClass:[ProductSizeObject class]]){
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Detail_Item_Size class]) forIndexPath:indexPath];
                [((Item_Detail_Item_Size *)cell) configureCellWithData:data];
            }
        }
            break;
        case 2:{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product class]) forIndexPath:indexPath];
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
            Top_Header *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Top_Header class]) forIndexPath:indexPath];
            [header configureHeaderWithTitle:@"関連"];
            reuseableView = header;
        }
    }else if(kind == UICollectionElementKindSectionFooter){
        if (![self sectionShouldHaveFooter:section]) {
            return nil;
        }else{
            if (section == 1) {
                Top_Footer *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([Top_Footer class]) forIndexPath:indexPath];
                
                TopFooterTouchHandler handler = nil;
                __weak ItemDetailScreen *weakSelf = self;
                __weak DescriptionCellInfo *weakCellInfo = _descriptionData;
                if (section == 1) {
                    //Show More Description
                    handler = ^{
                        NSLog(@"Show More Description");
                        weakCellInfo.isCollapsed = !weakCellInfo.isCollapsed;
                        //[weakSelf.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:([NSIndexPath indexPathForRow:2 inSection:section]) ]];
                        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
                    };
                }
                if(_descriptionData.isCollapsed){
                    [footer configureFooterWithTitle:@"もっと見る" withTouchHandler:handler];
                }else{
                    //TODO: need localize
                    [footer configureFooterWithTitle:@"show less" withTouchHandler:handler];
                }
                
                reuseableView = footer;
            }else if (section == 2){
                Top_Footer *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([Top_Footer class]) forIndexPath:indexPath];
                
                TopFooterTouchHandler handler = nil;
                __weak ItemDetailScreen *weakSelf = self;
                //Show More Description
                handler = ^{
                    NSLog(@"Show More Description");
                    [weakSelf getItemRelated];
                };
                [footer configureFooterWithTitle:@"もっと見る" withTouchHandler:handler];
                reuseableView = footer;
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
            height = [Item_Detail_TopImage getCellHeightWithWidth:width];
        }
            break;
        case 1:{
            width = superWidth;
            NSInteger index = indexPath.row;
            if (index == 0) {
                height = [Item_Detail_ItemName getCellHeightWithWidth:width];
            }else if (index == 1){
                height = [Item_Detail_Header_Segmented getCellHeightWithWidth:width];
            }else{
                if (_currentSwitchIndex == 0) {
                    if (_descriptionData.isCollapsed) {
                        height = DETAIL_DESCRIPTION_COLLAPSE;
                    }else{
                        height = _descriptionData.fullSizeHeight >= 0?_descriptionData.fullSizeHeight:DETAIL_DESCRIPTION_COLLAPSE;
                    }
                }else{
                    NSObject *item = [self dataForIndexPath:indexPath];
                    if ([item isKindOfClass:[DescriptionCellInfo class]]) {
                        DescriptionCellInfo *info = (DescriptionCellInfo *)item;
                        return CGSizeMake(superWidth,DETAIL_DESCRIPTION_COLLAPSE);
                    }else{
                        NSInteger column = [_item getNumberOfSizeColumn];
                        if (column <= 0) {
                            return CGSizeMake(superWidth, 30);
                        }else{
                            height = [Item_Detail_Item_Size getCellHeightWithWidth:0];
                            width = (superWidth)/column;
                        }
                    }
                }
            }
        }
            break;
        case 2:{
            width = (superWidth - 3*SPACING_ITEM_PRODUCT) / 2;
            height = [Item_Cell_Product getCellHeightWithWidth:width];
        }
            break;
        default:
            break;
    }
    
    return CGSizeMake(width, height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if(section == 2){
        return UIEdgeInsetsMake(10, 8, 5, 8);
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 2) {
        return 8;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 2) {
        return 8;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (![self sectionShouldHaveHeader:section]) {
        return CGSizeZero;
    }else{
        return CGSizeMake(collectionView.bounds.size.width, [Top_Header height]);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (![self sectionShouldHaveFooter:section]) {
        return CGSizeZero;
    }else{
        return CGSizeMake(collectionView.bounds.size.width, [Top_Footer height]);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *data = [self dataForIndexPath:indexPath];
    if ([data isKindOfClass:[ProductObject class]]) {
        ProductObject *product = (ProductObject *)data;
        ItemDetailScreen *controller = [[UIUtils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([ItemDetailScreen class])];
        controller.item = product;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)onHeaderSegmentedChange:(id)sender{
    if ([sender isKindOfClass:[TenpossSegmentedControl class]]) {
        _currentSwitchIndex = [((TenpossSegmentedControl *)sender) getSelectedIndex];
        NSLog(@"Value Changed to %ld", (long)_currentSwitchIndex);

        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
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

#pragma mark - SFSafariViewControllerDelegate

/*! @abstract Delegate callback called when the user taps the Done button. Upon this call, the view controller is dismissed modally. */
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{}

/*! @abstract Invoked when the initial URL load is complete.
 @param success YES if loading completed successfully, NO if loading failed.
 @discussion This method is invoked when SFSafariViewController completes the loading of the URL that you pass
 to its initializer. It is not invoked for any subsequent page loads in the same SFSafariViewController instance.
 */
- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully{}



@end
