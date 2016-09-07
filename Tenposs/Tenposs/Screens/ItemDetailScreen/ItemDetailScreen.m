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

@interface ItemDetailScreen ()

@property DescriptionCellInfo *descriptionData;

@end

@implementation ItemDetailScreen

- (instancetype)initWithItem:(ProductObject *)item{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _item = item;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    [self showLoadingViewWithMessage:@""];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Detail_TopImage class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Detail_TopImage class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Detail_ItemName class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Detail_ItemName class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Detail_Header_Segmented class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Detail_Header_Segmented class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Detail_Description class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Detail_Description class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Product class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Product class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Top_Header class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Top_Header class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Top_Footer class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([Top_Footer class])];
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

- (void)previewData{
    if(!_descriptionData){
        //TODO: Clear mockup
        _descriptionData = [[DescriptionCellInfo alloc]initWithFullText:@"Lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit. In diam ante, tempus ullamcorper erat at, placerat dictum diam. Suspendisse potenti. Fusce interdum, augue non interdum pellentesque, velit velit interdum ex, at sagittis sem nulla at ipsum. Proin posuere ex vitae odio cursus placerat. Nunc felis turpis, fringilla ut ultricies sed, sodales non elit. Phasellus sit amet lacus quis felis commodo sagittis. In eu ornare elit, venenatis hendrerit lorem. Donec elementum mollis elementum. Integer tempus sem non pellentesque lacinia. Etiam dapibus dictum sapien non convallis.\n\nCras id tincidunt diam. Nunc nibh metus, ultricies eu gravida elementum, feugiat in justo. Sed sed vestibulum velit. Sed et sapien eget elit sodales porttitor. In sed nisi dignissim, ultricies enim non, auctor purus. Sed consequat tellus quam, id consequat turpis vestibulum eget. Curabitur gravida nisl id vestibulum ultrices. Nulla ut nisi fermentum, consectetur ex id, dapibus nunc. Etiam tristique molestie posuere.\n\n\nSed blandit ligula sit amet finibus finibus. Suspendisse ornare diam non elit luctus varius. Morbi in erat vehicula, semper dolor eu, pellentesque eros. Cras consectetur scelerisque blandit. Nunc sit amet lobortis ante. Donec urna velit, lacinia ut tristique eu, ullamcorper nec lacus. Donec aliquet rutrum leo sit amet ultrices. Mauris tincidunt semper felis ut accumsan. Interdum et malesuada fames ac ante ipsum primis in faucibus. Ut non elit eget dui vulputate molestie. Etiam lobortis lacinia feugiat. Nullam convallis nibh ante, a laoreet mauris tempus ut. Donec id sapien quis lectus facilisis ullamcorper. Nulla egestas sit amet ex vitae ultrices.\n\nClass aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Cras imperdiet nibh id nisl euismod, id scelerisque dui hendrerit. Suspendisse diam sem, elementum sit amet lorem quis, porta molestie velit. Quisque sollicitudin erat et lectus molestie volutpat. Curabitur pharetra nulla a velit placerat convallis. Aliquam neque libero, feugiat a malesuada et, commodo at eros. Cras augue magna, tristique ut sem eu, egestas elementum ipsum. Vivamus sodales rhoncus nibh sit amet hendrerit. Integer fringilla eleifend blandit. Cras mattis ligula eu eros sodales, et dapibus lectus fermentum.\n\nQuisque arcu eros, interdum sit amet ipsum a, efficitur condimentum libero. Aliquam sed consequat ipsum, et commodo nibh. Duis vulputate elit imperdiet, pharetra velit maximus, pellentesque justo. Interdum et malesuada fames ac ante ipsum primis in faucibus. Quisque placerat aliquet nisl, quis vestibulum quam tristique ac. Aenean maximus felis eu mauris eleifend egestas id sed eros. Vivamus a nisi venenatis, luctus sem quis, mattis tellus."];
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
    if (section == 2 || section == 1) {
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
            break;
        case 1:{
            NSInteger index = indexPath.row;
            if (index == 0) {
                return _item;
            }else if (index == 1){
                return _item;
            }else{
                return _descriptionData;//_item.desc;
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
            return 3;
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
            }else if (index == 1){
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Detail_Header_Segmented class]) forIndexPath:indexPath];
            }else{
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Detail_Description class]) forIndexPath:indexPath];
                [((Item_Detail_Description *)cell) configureCellWithData:data WithWidth:self.collectionView.bounds.size.width - 16];
                return cell;
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
            [header configureHeaderWithTitle:@"Related"];
            reuseableView = header;
        }
    }else if(kind == UICollectionElementKindSectionFooter){
        if (![self sectionShouldHaveFooter:section]) {
            return nil;
        }else{
            Top_Footer *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([Top_Footer class]) forIndexPath:indexPath];

            TopFooterTouchHandler handler = nil;
            __weak ItemDetailScreen *weakSelf = self;
            __weak DescriptionCellInfo *weakCellInfo = _descriptionData;
            if (section == 1) {
                //Show More Description
                handler = ^{
                    NSLog(@"Show More Description");
                    weakCellInfo.isCollapsed = !weakCellInfo.isCollapsed;
                    [weakSelf.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:([NSIndexPath indexPathForRow:2 inSection:section]) ]];
                };
            }
            
            [footer configureFooterWithTitle:@"View More" withTouchHandler:handler];
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
                if (_descriptionData.isCollapsed) {
                    height = DETAIL_DESCRIPTION_COLLAPSE;
                }else{
                    height = _descriptionData.fullSizeHeight;
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

//#pragma mark - TenpossCommunicatorDelegate
//
//- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
//    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
//    NSError *error = nil;
//    if (errorCode != ERROR_OK) {
//        NSString *errorDomain = [responseParams get:KeyResponseError];
//        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
//    }else{
//        _itemDetail = (ItemDetailResponse *)[responseParams get:KeyResponseObject];
//        [self previewData];
//    }
//}
//
//- (void)begin:(TenpossCommunicator*)request data:(Bundle*) responseParams{
//
//}
//
//-( void)cancelAllRequest{
//
//}


@end
