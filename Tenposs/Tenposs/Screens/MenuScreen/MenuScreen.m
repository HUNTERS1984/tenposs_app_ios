//
//  MenuScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "MenuScreen.h"
#import "MenuScreenDataSource.h"
#import "MenuCommunicator.h"
#import "UIViewController+LoadingView.h"
#import "UIView+LoadingView.h"
#import "ItemDetailScreen.h"
#import "UIUtils.h"
#import "SVPullToRefresh.h"
#import "UIFont+Themify.h"
#import "HexColors.h"
#import "AppConfiguration.h"

@interface MenuScreen ()<UICollectionViewDelegateFlowLayout>

/// UI components
@property (weak, nonatomic) IBOutlet UIButton *nextCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *previousCategoryButton;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *detailLoadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *detailLoadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *detailLoadingMessage;

/// Data source
@property (strong, nonatomic) MenuScreenDataSource *dataSource;

@end

@implementation MenuScreen

- (void)loadView{
    [super loadView];
    self.dataSource = [[MenuScreenDataSource alloc] initAndShouldShowLatest:YES];
    self.dataSource.collectionView = self.collectionView;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *settings = [appConfig getAvailableAppSettings];
    
    [_previousCategoryButton setFont:[UIFont themifyFontOfSize:[UIUtils getTextSizeWithType:settings.font_size]]];
    [_previousCategoryButton setTitle:[NSString stringWithFormat: [UIFont stringForThemifyIdentifier:@"ti-arrow-left"]] forState:UIControlStateNormal];
    [_nextCategoryButton setFont:[UIFont themifyFontOfSize:[UIUtils getTextSizeWithType:settings.font_size]]];
    [_nextCategoryButton setTitle:[NSString stringWithFormat: [UIFont stringForThemifyIdentifier:@"ti-arrow-right"]] forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    
    [self showLoadingViewWithMessage:@""];
    
    __weak __typeof__(self) weakSelf = self;
    __weak __typeof__(self.dataSource) wDataSource = self.dataSource;
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf.nextCategoryButton setEnabled:NO];
        [weakSelf.previousCategoryButton setEnabled:NO];
        [wDataSource loadMoreDataWithCompleteHandler:^(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious) {
            [weakSelf handleDataSourceCallback:error title:detailDataSourceTitle hasNext:hasNext hasPrevious:hasPrevious];
        }];
    }];
    
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf.nextCategoryButton setEnabled:NO];
        [weakSelf.previousCategoryButton setEnabled:NO];
        [wDataSource reloadDataWithCompleteHandler:^(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious) {
            [weakSelf handleDataSourceCallback:error title:detailDataSourceTitle hasNext:hasNext hasPrevious:hasPrevious];
        }];
    }];
    
    [self.dataSource fetchDataWithCompleteHandler:^(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious) {
        [weakSelf handleDataSourceCallback:error title:detailDataSourceTitle hasNext:hasNext hasPrevious:hasPrevious];
    }];
}

- (void)handleDataSourceCallback:(NSError *)error title:(NSString *)detailDataSourceTitle hasNext:(BOOL)hasNext hasPrevious:(BOOL) hasPrevious{
    
    [self.collectionView.infiniteScrollingView stopAnimating];
    [self.collectionView.pullToRefreshView stopAnimating];
    
    [self handleDataSourceError:error];
    
    [self updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
    self.collectionView.dataSource = self.dataSource.activeDetailDataSource;
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title{
    return @"Menu";
}

- (void)handleDataSourceError:(NSError *)error{
    if (!error) {
        [self removeLoadingView];
        [self showDetailLoadingView:NO message:nil];
        return;
    }
        [self removeLoadingView];
        NSString *message = @"Unknow Error";
        switch (error.code) {
            case ERROR_DATASOURCE_NO_CONTENT:
                //TODO: need localize
                message = @"NO CONTENT";
                [self showErrorScreen:message];
                break;
            case ERROR_DETAIL_DATASOURCE_NO_CONTENT:
                message = @"NO CONTENT";
                [self showDetailLoadingView:YES message:message];
                break;
            case ERROR_CONTENT_FULLY_LOADED:
                [self showDetailLoadingView:NO message:nil];
                break;
            case ERROR_DETAIL_DATASOURCE_IS_LAST:{
                [self.nextCategoryButton setEnabled:NO];
                [self showDetailLoadingView:NO message:nil];
            }break;
                
            case ERROR_DETAIL_DATASOURCE_IS_FIRST:{
                [self.previousCategoryButton setEnabled:NO];
                [self showDetailLoadingView:NO message:nil];
            }break;
            default:
                break;
        }
}

- (void)showDetailLoadingView:(BOOL)show message:(NSString *)message{
    if (show) {
        if (message) {
            [self.detailLoadingView setHidden:NO];
            [self.detailLoadingIndicator stopAnimating];
            [self.detailLoadingIndicator setHidden:YES];
            [self.detailLoadingMessage setHidden:NO];
            [self.detailLoadingMessage setText:message];
        }else{
            [self.detailLoadingView setHidden:NO];
            [self.detailLoadingIndicator setHidden:NO];
            [self.detailLoadingMessage setHidden:YES];
            [self.detailLoadingIndicator startAnimating];
        }
    }else {
        [self.detailLoadingView setHidden:YES];
        [self.detailLoadingIndicator stopAnimating];
    }
}

- (void)removeInfiniteLoading{
    [self.collectionView.infiniteScrollingView stopAnimating];
    self.collectionView.showsInfiniteScrolling = NO;
}

- (void)removePullToRefresh{
    [self.collectionView.pullToRefreshView stopAnimating];
    self.collectionView.showsPullToRefresh = NO;
}

#pragma mark - UI methods

- (IBAction)buttonClick:(id)sender {
    if (sender == self.nextCategoryButton) {
        [self showDetailLoadingView:YES message:nil];
        [self.nextCategoryButton setEnabled:NO];
        [self.previousCategoryButton setEnabled:NO];
        __weak MenuScreen *weakSelf = self;
        [self.dataSource changeToNextDetailDataSourceWithCompleteHandler:^(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious) {
            [weakSelf handleDataSourceCallback:error title:detailDataSourceTitle hasNext:hasNext hasPrevious:hasPrevious];
        }];
    }else if(sender == self.previousCategoryButton){
        [self showDetailLoadingView:YES message:nil];
        [self.nextCategoryButton setEnabled:NO];
        [self.previousCategoryButton setEnabled:NO];
        __weak MenuScreen *weakSelf = self;
        [self.dataSource changeToPreviousDetailDataSourceWithCompleteHandler:^(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious) {
            [weakSelf handleDataSourceCallback:error title:detailDataSourceTitle hasNext:hasNext hasPrevious:hasPrevious];
        }];
    }
}

- (void)updateCategoryNavigationWithTitle:(NSString *)title showNext:(BOOL)hasNext showPrevious:(BOOL)hasPrevious{
    [self.categoryTitle setText:title];
    if (hasNext) {
        [self.nextCategoryButton setEnabled:YES];
    }else{
        [self.nextCategoryButton setEnabled:NO];
    }
    if (hasPrevious) {
        [self.previousCategoryButton setEnabled:YES];
    }else{
        [self.previousCategoryButton setEnabled:NO];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *item = [self.dataSource itemAtIndexPath:indexPath];
    if ([item isKindOfClass:[ProductObject class]]) {
        ProductObject *product = (ProductObject *)item;
        ItemDetailScreen *controller = [[UIUtils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([ItemDetailScreen class])];
        controller.item = product;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dataSource.activeDetailDataSource sizeForCellAtIndexPath:indexPath withCollectionWidth:collectionView.bounds.size.width];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 8, 5, 8);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return [self.dataSource.activeDetailDataSource sizeForHeaderAtSection:section inCollectionView:collectionView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return [self.dataSource.activeDetailDataSource sizeForFooterAtSection:section inCollectionView:collectionView];
}

@end
