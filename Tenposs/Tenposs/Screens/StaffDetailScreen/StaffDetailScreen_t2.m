//
//  StaffDetailScreen_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/9/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "StaffDetailScreen_t2.h"

#import "ItemDetailCommunicator.h"

#import "Item_Detail_ItemName_t2.h"
#import "Item_Cell_Product_Item_t2.h"
#import "Item_Detail_TopImage.h"
#import "Item_Detail_Description.h"
#import "Center_Text_Header.h"
#import "Left_Text_Header.h"
#import "Left_Text_Footer.h"
#import "Center_Text_Footer.h"
#import "Item_Cell_StaffInfo.h"
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


@interface StaffDetailScreen_t2 ()

@property DescriptionCellInfo *introductionData;
@property DescriptionCellInfo *informationData;

@end

@implementation StaffDetailScreen_t2

- (instancetype)initWithStaff:(StaffObject *)staff{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _staff = staff;
    }
    return self;
}

- (NSString *)title{
    return _staff.name;
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
        
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                         [UIColor colorWithHexString:settings.title_color], NSForegroundColorAttributeName,nil]];
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
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_StaffInfo class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_StaffInfo class])];
    

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
    
    [self previewData];
}



- (void)handleRequestError:(NSError *)error{
    //TODO: show Error screen
}

-(void)previewData{
    if(!_introductionData){
        //TODO: Clear mockup
        _introductionData = [[DescriptionCellInfo alloc]initWithFullText:_staff.introduction];
        [_introductionData calculateFullTextHeightWithWidth:(self.collectionView.bounds.size.width - 16)];
        _introductionData.isCollapsed = NO;
    }
    
    [self.collectionView reloadData];
    [self removeLoadingView];
}


#pragma mark - UICollectionViewDataSource

-(BOOL)sectionShouldHaveHeader:(NSInteger)section{
    if (section == 0 || section == 1) {
        return NO;
    }else if (section == 3){
        return YES;
    }
    return YES;
}

-(BOOL)sectionShouldHaveFooter:(NSInteger)section{
    if (section == 3){
        return NO;
    }else if (section == 2) {
        if (_introductionData.fullSizeHeight <= DETAIL_DESCRIPTION_COLLAPSE) {
            return NO;
        }
        return YES;
    }
    return NO;
}

- (NSObject *)dataForIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:{
            return _staff.image_url;
        }
        case 1:{
            return _staff;
        }
        case 2:{
            if (!_staff.description) {
                _introductionData.fullText = @"データなし";
            }else{
                if ([_staff.description isEqualToString:@""]) {
                    _introductionData.fullText = @"データなし";
                }
            }
            return _introductionData;//_item.desc;
        }
        case 3:{
            return _staff;
        }
        default:
            return nil;
            break;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        case 1:
        case 2:
            return 1;
        case 3:{
            return 1;
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
            [((Item_Detail_Description *)cell) configureCellWithData:data WithWidth:self.collectionView.bounds.size.width - 16];
            return cell;
        }
            break;
        case 3:{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_StaffInfo class]) forIndexPath:indexPath];
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
                    [((Left_Text_Header *)header).title setFont:[UIFont systemFontOfSize:18 weight:200]];
                    reuseableView = header;
                }
                    break;
                case 3:{
                    Left_Text_Header *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Left_Text_Header class]) forIndexPath:indexPath];
                    [((Left_Text_Header *)header).title setText:@"プロフィール"];
                    [((Left_Text_Header *)header).title setFont:[UIFont systemFontOfSize:18 weight:200]];
                    reuseableView = header;
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
                    
                    __weak StaffDetailScreen_t2 *weakSelf = self;
                    __weak DescriptionCellInfo *weakCellInfo = _introductionData;
                    [((Left_Text_Footer *)footer).footerButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                        weakCellInfo.isCollapsed = !weakCellInfo.isCollapsed;
                        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
                    }];
                    if(_introductionData.isCollapsed){
                        [((Left_Text_Footer *)footer).title setText:@"もっと見る"];
                    }else{
                        //TODO: need localize
                        [((Left_Text_Footer *)footer).title setText:@"閉じる"];
                    }
                    [((Left_Text_Footer *)footer).title setTextColor:[UIColor colorWithHexString:@"3CB963"]];
                    reuseableView = footer;
                    break;
                }
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
            width = superWidth - 2*5;
            if (_introductionData.isCollapsed) {
                height = DETAIL_DESCRIPTION_COLLAPSE;
            }else{
                height = _introductionData.fullSizeHeight >= 10?_introductionData.fullSizeHeight:DETAIL_DESCRIPTION_COLLAPSE;
            }
        }
            break;
        case 3:{
            width = superWidth - 2*5;
            height = [Item_Cell_StaffInfo getCellHeightWithWidth:width];
        }
            break;
        default:
            break;
    }
    
    return CGSizeMake(width, height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    if(section == 2) {
        return UIEdgeInsetsMake(0, 5, 0, 5);
    }
    else if(section == 3){
        return UIEdgeInsetsMake(0, 5, 0, 5);
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


@end
