//
//  GalleryScreen_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/15/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "GalleryScreen_t2.h"
#import "UIViewController+LoadingView.h"
#import "AppConfiguration.h"
#import "UIFont+Themify.h"
#import "HexColors.h"


#define t2_Photo_Line_Count 3

@interface GalleryScreen_t2 ()

@end

@implementation GalleryScreen_t2

- (void)loadView{
    [super loadView];
    PhotoCategory *photoCate = [[PhotoCategory alloc] init];
    photoCate.category_id = 0;
    _dataSource = [[GalleryScreenDetailDataSource alloc] initWithPhotoCategory:photoCate];
    _dataSource.delegate = self;
    self.collectionView.dataSource = _dataSource;
    [_dataSource registerClassForCollectionView:self.collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        [self.navigationItem.leftBarButtonItem setTitle:[NSString stringWithFormat: @"%@", [UIFont stringForThemifyIdentifier:@"ti-angle-left"]]];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                         [UIColor colorWithHexString:settings.title_color], NSForegroundColorAttributeName,nil]];
    }
}

- (void)didPressBackButton{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.view setNeedsLayout];
    
    RFQuiltLayout* layout = (id)[self.collectionView collectionViewLayout];
    layout.delegate = self;
    layout.direction = UICollectionViewScrollDirectionVertical;
    layout.blockPixels = [self getBlockSizeWithFullWidth:[UIScreen mainScreen].bounds.size.width];
    
    [self.collectionView reloadData];
    
    [_dataSource loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title{
    return @"写真";
}

#pragma mark – RFQuiltLayoutDelegate

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self getCellSizeForIndex:indexPath.row];
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *item = [_dataSource itemAtIndexPath:indexPath];
    if([item isKindOfClass:[PhotoObject class]]){
        AppSettings *settings = [[AppConfiguration sharedInstance] getAvailableAppSettings];
        PhotoObject *photo = (PhotoObject *)item;
        Bundle *extra = [Bundle new];
        [extra put:PhotoViewer_PHOTO value:photo];
        UIViewController *photoViewer = [GlobalMapping getPhotoViewer:settings.template_id andExtra:extra];
        [self presentViewController:photoViewer animated:YES completion:nil];
    }
}

#pragma mark - Private Methods

- (CGSize)getBlockSizeWithFullWidth:(CGFloat)fullWidth{
    CGFloat width = 0;
    CGFloat height = 0;
    
    width = fullWidth/t2_Photo_Line_Count;
    height = width;
    
    return CGSizeMake(width, height);
}

- (CGSize)getCellSizeForIndex:(NSUInteger)index{
    
    NSInteger remain = -1;
    
    if (index <= 10) {
        remain = index + 1;
    }else{
        remain = index % 10;
    }
    
    if (remain == 1 || remain == 2 || remain == 3 || remain == 5 || remain == 6 || remain == 7 || remain == 8 || remain == 9){
        return CGSizeMake(1, 1);
    }else if (remain == 4){
        return CGSizeMake(2, 2);
    }else if (remain == 0 || remain == 10){
        return CGSizeMake(3, 3);
    }
    
    return CGSizeMake(0, 0);
}

- (void)handleDataSourceError:(NSError *)error{
    if (!error) {
        [self removeAllInfoView];
        [self.collectionView reloadData];
        return;
    }
    [self removeAllInfoView];
    NSString *message = @"Unknow Error";
    switch (error.code) {
        case ERROR_DATASOURCE_NO_CONTENT:{
            message = NSLocalizedString(@"NO CONTENT",nil);
            [self showErrorScreen:message];
        }
            break;
        case ERROR_DETAIL_DATASOURCE_NO_CONTENT:{
            message = NSLocalizedString(@"NO CONTENT",nil);
            [self showErrorScreen:message];
        }
            break;
        case ERROR_CONTENT_FULLY_LOADED:{
            
        }
            break;
        case ERROR_DETAIL_DATASOURCE_IS_LAST:{
        }break;
        case ERROR_DETAIL_DATASOURCE_IS_FIRST:{
        }break;
        case ERROR_INVALID_TOKEN:{
            [self invalidateCurrentUserSession];
        }break;
        default:
            break;
    }
}

#pragma mark - SimpleDataSourceDelegate

- (void)dataLoaded:(SimpleDataSource *)executor withError:(NSError *)error{
    [self handleDataSourceError:error];
}

- (void)needRefreshItemAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)needRefreshSectionAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
