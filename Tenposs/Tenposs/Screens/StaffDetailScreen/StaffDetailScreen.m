//
//  StaffDetailScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "StaffDetailScreen.h"
#import "TenpossSegmentedControl.h"
#import "UIViewController+LoadingView.h"
#import "Item_Detail_ItemName.h"
#import "Item_Detail_TopImage.h"
#import "Item_Detail_Description.h"
#import "Item_Detail_Header_Segmented.h"
#import "Top_Header.h"
#import "AppConfiguration.h"
#import "UIFont+Themify.h"
#import "Top_Footer.h"
#import "HexColors.h"
#import "UIUtils.h"
#import "Utils.h"


#define COLLAPESED_HEIGHT 120

@interface StaffDetailScreen ()

//{
//    bool isCollapsed;
//    CGFloat collapseContentViewHeight;
//}
//@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
//@property (weak, nonatomic) IBOutlet UIView *contentView;
//@property (weak, nonatomic) IBOutlet UILabel *subtitle;
//@property (weak, nonatomic) IBOutlet UILabel *staffTitle;
//@property (weak, nonatomic) IBOutlet UIButton *goToButton;
//@property (weak, nonatomic) IBOutlet TenpossSegmentedControl *segmentedControl;
//@property (weak, nonatomic) IBOutlet UITextView *desc;
//@property (weak, nonatomic) IBOutlet UIButton *showMoreButton;
//
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descHeightConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
//

@property DescriptionCellInfo *introductionData;
@property DescriptionCellInfo *informationData;

@property NSInteger currentSwitchIndex;

@end

@implementation StaffDetailScreen

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
    
    [self showLoadingViewWithMessage:@""];
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *settings = [appConfig getAvailableAppSettings];
    
    if ([[self.navigationController viewControllers] count] > 1) {
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
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Detail_TopImage class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Detail_TopImage class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Detail_ItemName class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Detail_ItemName class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Detail_Header_Segmented class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Detail_Header_Segmented class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Detail_Description class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Detail_Description class])];
    
//    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Top_Footer class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([Top_Footer class])];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self previewData];
}

-(void)previewData{
    if(!_introductionData){
        //TODO: Clear mockup
        _introductionData = [[DescriptionCellInfo alloc]initWithFullText:_staff.introduction];
        [_introductionData calculateFullTextHeightWithWidth:(self.collectionView.bounds.size.width - 16)];
        _introductionData.isCollapsed = NO;
    }
    if (!_informationData) {
        NSString *infoString = @"";
        
        if (_staff.name && ![_staff.name isEqualToString:@""]) {
            infoString = [infoString stringByAppendingString:[NSString stringWithFormat:@"Name: %@", _staff.name]];
            infoString = [infoString stringByAppendingString:@"\n\n"];
        }
        if (_staff.price && ![_staff.price isEqualToString:@""]) {
            infoString = [infoString stringByAppendingString:[NSString stringWithFormat:@"Price: %@", [Utils formatPriceToJapaneseFormat:_staff.price]]];
            infoString = [infoString stringByAppendingString:@"\n\n"];
        }
        if (_staff.birthday && ![_staff.birthday isEqualToString:@""]) {
            infoString = [infoString stringByAppendingString:[NSString stringWithFormat:@"Birthday: %@", _staff.birthday]];
            infoString = [infoString stringByAppendingString:@"\n\n"];
        }
        if (_staff.gender && ![_staff.gender isEqualToString:@""]) {
            infoString = [infoString stringByAppendingString:[NSString stringWithFormat:@"Gender: %@", _staff.gender]];
            infoString = [infoString stringByAppendingString:@"\n\n"];
        }
        if (_staff.tel && ![_staff.tel isEqualToString:@""]) {
            infoString = [infoString stringByAppendingString:[NSString stringWithFormat:@"Tel: %@", _staff.tel]];
            infoString = [infoString stringByAppendingString:@"\n\n"];
        }
        
        _informationData = [[DescriptionCellInfo alloc]initWithFullText:infoString];
        [_informationData calculateFullTextHeightWithWidth:(self.collectionView.bounds.size.width - 16)];
        _informationData.isCollapsed = NO;
    }
    [self.collectionView reloadData];
    [self removeLoadingView];
}

#pragma mark - UICollectionViewDataSource

-(BOOL)sectionShouldHaveFooter:(NSInteger)section{
//    if (section == 1) {
//        if (_currentSwitchIndex == 0) {
//            if (_introductionData.fullSizeHeight <= DETAIL_DESCRIPTION_COLLAPSE) {
//                return NO;
//            }else{
//                return YES;
//            }
//        }else if (_currentSwitchIndex == 1){
//            if (_informationData.fullSizeHeight <= DETAIL_DESCRIPTION_COLLAPSE) {
//                return NO;
//            }else{
//                return YES;
//            }
//        }
//    }
    return NO;
}

- (NSObject *)dataForIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:{
            return _staff.image_url;
        }
            break;
        case 1:{
            NSInteger index = indexPath.row;
            if (index == 0) {
                //Staff name
                return _staff;
            }else if (index == 1){
                //segmented header
                return _staff;
            }else{
                if (_currentSwitchIndex == 0) {
                    return _introductionData;
                }else if (_currentSwitchIndex == 1){
                    return _informationData;
                }
            }
        }
            break;
        default:
            return nil;
            break;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
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
            }else if (index == 1){
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Detail_Header_Segmented class]) forIndexPath:indexPath];
                [((Item_Detail_Header_Segmented *)cell).segmentControl setItems:[NSMutableArray arrayWithObjects:NSLocalizedString(@"staff_description", nil),NSLocalizedString(@"staff_profile", nil), nil]];
                [((Item_Detail_Header_Segmented *)cell).segmentControl addTarget:self action:@selector(onHeaderSegmentedChange:) forControlEvents:UIControlEventValueChanged];
                [((Item_Detail_Header_Segmented *)cell).segmentControl setSelectedIndex:_currentSwitchIndex];
                [((Item_Detail_Header_Segmented *)cell).segmentControl setSelectedIndex:_currentSwitchIndex];
            }else{
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Detail_Description class]) forIndexPath:indexPath];
                [((Item_Detail_Description *)cell) configureCellWithData:data WithWidth:self.collectionView.bounds.size.width - 16];
                return cell;
            }
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
    
    if(kind == UICollectionElementKindSectionFooter){
        if (![self sectionShouldHaveFooter:section]) {
            return nil;
        }else{
            Top_Footer *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([Top_Footer class]) forIndexPath:indexPath];
            
            TopFooterTouchHandler handler = nil;
            __weak StaffDetailScreen *weakSelf = self;
            
            __weak DescriptionCellInfo *weakCellInfo = nil;
            if (_currentSwitchIndex == 0) {
                weakCellInfo = _introductionData;
            }else if (_currentSwitchIndex == 1){
                weakCellInfo = _informationData;
            }
            if (section == 1) {
                //Show More Description
                handler = ^{
                    NSLog(@"Show More Description");
                    if (weakCellInfo) {
                        weakCellInfo.isCollapsed = !weakCellInfo.isCollapsed;
                    }
                    [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
                };
            }
            if(_introductionData.isCollapsed){
                [footer configureFooterWithTitle:@"もっと見る" withTouchHandler:handler];
            }else{
                //TODO: need localize
                [footer configureFooterWithTitle:@"show less" withTouchHandler:handler];
            }
            
            reuseableView = footer;
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
                if (_introductionData.isCollapsed) {
                    height = _introductionData.fullSizeHeight;
                }else{
                    height = _introductionData.fullSizeHeight;
                }
            }
            
        }
            break;
        default:
            break;
    }
    
    return CGSizeMake(width, height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
        return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (![self sectionShouldHaveFooter:section]) {
        return CGSizeZero;
    }else{
        return CGSizeMake(collectionView.bounds.size.width, [Top_Footer height]);
    }
}

#pragma mark - Private Methods

- (void)onHeaderSegmentedChange:(id)sender{
    if ([sender isKindOfClass:[TenpossSegmentedControl class]]) {
        _currentSwitchIndex = [((TenpossSegmentedControl *)sender) getSelectedIndex];
        NSLog(@"Value Changed to %ld", (long)_currentSwitchIndex);
        
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    }
}

- (void)didPressBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
