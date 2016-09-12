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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    
    [self showLoadingViewWithMessage:@""];
    
    __weak MenuScreen *weakSelf = self;
    [self.dataSource fetchDataWithCompleteHandler:^(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious) {
//        if (error) {
//            [weakSelf handleDataSourceError:error];
//        }else{
            [weakSelf updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
            weakSelf.collectionView.dataSource = weakSelf.dataSource.activeDetailDataSource;
            [weakSelf.collectionView reloadData];
            [weakSelf removeLoadingView];
            [weakSelf showDetailLoadingView:NO message:nil];
//        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title{
    return @"Menu";
}

- (void)handleDataSourceError:(NSError *)error{
    [UIView animateWithDuration:0.2 animations:^{
        [self removeLoadingView];
        NSString *message = @"Unknow Error";
        switch (error.code) {
            case ERROR_NO_CONTENT:
                message = @"NO CONTENT";
                break;
            
            default:
                break;
        }
        [self showErrorScreen:message];
    }];
}

- (void)handleDetailDataSourceError:(NSError *)error{
    [UIView animateWithDuration:0.2 animations:^{
        [self removeLoadingView];
        NSString *message = @"Unknow Error";
        switch (error.code) {
            case ERROR_NO_CONTENT:
                message = @"NO CONTENT";
                break;
                
            default:
                break;
        }

        [self showDetailLoadingView:YES message:message];
    }];
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
            [self.detailLoadingIndicator startAnimating];
        }
    }else {
        [self.detailLoadingView setHidden:YES];
        [self.detailLoadingIndicator stopAnimating];
    }
}

#pragma mark - UI methods

- (IBAction)buttonClick:(id)sender {
    if (sender == self.nextCategoryButton) {
        [self showDetailLoadingView:YES message:nil];
        [self.nextCategoryButton setEnabled:NO];
        [self.previousCategoryButton setEnabled:NO];
        __weak MenuScreen *weakSelf = self;
        [self.dataSource changeToNextDetailDataSourceWithCompleteHandler:^(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious) {
            if (!error) {
                [weakSelf updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
                weakSelf.collectionView.dataSource = weakSelf.dataSource.activeDetailDataSource;
                [weakSelf.collectionView reloadData];
                [weakSelf showDetailLoadingView:NO message:nil];
            }else{
                if(error.code == ERROR_DATASOURCE_IS_LAST){
                    [weakSelf updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
                    weakSelf.collectionView.dataSource = weakSelf.dataSource.activeDetailDataSource;
                    [weakSelf.collectionView reloadData];
                    [weakSelf.nextCategoryButton setEnabled:NO];
                }else{
                    [weakSelf handleDetailDataSourceError:error];
                    [weakSelf updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
                }
            }
        }];
    }else if(sender == self.previousCategoryButton){
        [self showDetailLoadingView:YES message:nil];
        [self.nextCategoryButton setEnabled:NO];
        [self.previousCategoryButton setEnabled:NO];
        __weak MenuScreen *weakSelf = self;
        [self.dataSource changeToPreviousDetailDataSourceWithCompleteHandler:^(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious) {
            if (!error) {
                [weakSelf updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
                weakSelf.collectionView.dataSource = weakSelf.dataSource.activeDetailDataSource;
                [weakSelf.collectionView reloadData];
                [weakSelf showDetailLoadingView:NO message:nil];
            }else{
                if (error.code  == ERROR_DATASOURCE_IS_FIRST) {
                    [weakSelf updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
                    weakSelf.collectionView.dataSource = weakSelf.dataSource.activeDetailDataSource;
                    [weakSelf.collectionView reloadData];
                    [weakSelf.previousCategoryButton setEnabled:NO];
                }else{
                    [weakSelf handleDetailDataSourceError:error];
                    [weakSelf updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];

                }
            }
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

#pragma mark - Communicator


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
