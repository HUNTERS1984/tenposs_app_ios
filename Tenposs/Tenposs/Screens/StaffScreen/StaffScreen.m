//
//  StaffScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/11/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "StaffScreen.h"
#import "StaffScreenDataSource.h"
#import "UIViewController+LoadingView.h"
#import "UIUtils.h"
#import "CommunicatorConst.h"
#import "StaffDetailScreen.h"

@interface StaffScreen ()<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIButton *previousCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *nextCategoryButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;

@property (weak, nonatomic) IBOutlet UIView *detailLoadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *detailLoadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *detailLoadingMessage;

/// Data source
@property (strong, nonatomic) StaffScreenDataSource *dataSource;

@end

@implementation StaffScreen

- (void)loadView{
    [super loadView];
    self.dataSource = [[StaffScreenDataSource alloc] initAndShouldShowLatest:YES];
    self.dataSource.collectionView = self.collectionView;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    
    [self showLoadingViewWithMessage:@""];
    
    __weak StaffScreen *weakSelf = self;
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
            case ERROR_DATASOURCE_NO_CONTENT:
                message = @"NO CONTENT";
                break;
            case ERROR_DETAIL_DATASOURCE_NO_CONTENT:
                //TODO:implementation
                break;
            default:
                break;
        }
        [self showErrorScreen:message];
    }];
}

- (void)handleDetailDataSourceError:(NSError *)error{
    [UIView animateWithDuration:0.2 animations:^{
        [self showDetailLoadingView:YES message:error.domain];
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
        __weak StaffScreen *weakSelf = self;
        [self.dataSource changeToNextDetailDataSourceWithCompleteHandler:^(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious) {
            if (!error) {
                [weakSelf updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
                weakSelf.collectionView.dataSource = weakSelf.dataSource.activeDetailDataSource;
                [weakSelf.collectionView reloadData];
                [weakSelf showDetailLoadingView:NO message:nil];
            }else{
                if(error.code == ERROR_DETAIL_DATASOURCE_IS_LAST){
                    [weakSelf updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
                    weakSelf.collectionView.dataSource = weakSelf.dataSource.activeDetailDataSource;
                    [weakSelf.collectionView reloadData];
                    [weakSelf.nextCategoryButton setEnabled:NO];
                }else{
                    [weakSelf handleDetailDataSourceError:error];
                }
            }
        }];
    }else if(sender == self.previousCategoryButton){
        [self showDetailLoadingView:YES message:nil];
        [self.nextCategoryButton setEnabled:NO];
        [self.previousCategoryButton setEnabled:NO];
        __weak StaffScreen *weakSelf = self;
        [self.dataSource changeToPreviousDetailDataSourceWithCompleteHandler:^(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious) {
            if (!error) {
                [weakSelf updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
                weakSelf.collectionView.dataSource = weakSelf.dataSource.activeDetailDataSource;
                [weakSelf.collectionView reloadData];
                [weakSelf showDetailLoadingView:NO message:nil];
            }else{
                if (error.code == ERROR_DETAIL_DATASOURCE_IS_FIRST) {
                    [weakSelf updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
                    weakSelf.collectionView.dataSource = weakSelf.dataSource.activeDetailDataSource;
                    [weakSelf.collectionView reloadData];
                    [weakSelf.previousCategoryButton setEnabled:NO];
                }else{
                    [weakSelf handleDetailDataSourceError:error];
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

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *item = [self.dataSource itemAtIndexPath:indexPath];
    if ([item isKindOfClass:[StaffObject class]]) {
        StaffObject *staff = (StaffObject *)item;
        StaffDetailScreen *controller = [[UIUtils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([StaffDetailScreen class])];
        controller.staff = staff;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dataSource.activeDetailDataSource sizeForCellAtIndexPath:indexPath withCollectionWidth:collectionView.bounds.size.width];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return [self.dataSource.activeDetailDataSource sizeForHeaderAtSection:section inCollectionView:collectionView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return [self.dataSource.activeDetailDataSource sizeForFooterAtSection:section inCollectionView:collectionView];
}

@end
