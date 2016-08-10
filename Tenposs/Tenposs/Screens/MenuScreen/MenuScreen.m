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

@interface MenuScreen ()<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/// UI components
@property (weak, nonatomic) IBOutlet UIButton *nextCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *previousCategoryButton;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

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
    
    [self.dataSource fetchDataWithCompleteHandler:^(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious) {
        if (error) {
            [UIView animateWithDuration:0.5 animations:^{
                [self removeLoadingView];
                [self showLoadingViewWithMessage:error.domain?:@"Error"];
            }];
        }else{
            [self updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
            self.collectionView.dataSource = self.dataSource.activeDetailDataSource;
            [self.collectionView reloadData];
            [self removeLoadingView];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI methods

- (IBAction)buttonClick:(id)sender {
    if (sender == self.nextCategoryButton) {
        [self.nextCategoryButton setEnabled:NO];
        [self.previousCategoryButton setEnabled:NO];
//        [self.collectionView showLoadingView];
        [self.dataSource changeToNextDetailDataSourceWithCompleteHandler:^(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious) {
            if (!error) {
                [self updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
                self.collectionView.dataSource = self.dataSource.activeDetailDataSource;
                [self.collectionView reloadData];
//                [self.collectionView removeLoadingView];
            }else{
                if([error.domain isEqualToString:MenuScreenError_isLast]){
                    [self updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
                    self.collectionView.dataSource = self.dataSource.activeDetailDataSource;
                    [self.collectionView reloadData];
                    [self.nextCategoryButton setEnabled:NO];
                }else{
                    NSLog(@"MenuScreen - Change dataSource failed - Error :%@", error.domain);
                }
            }
        }];
    }else if(sender == self.previousCategoryButton){
        [self.nextCategoryButton setEnabled:NO];
        [self.previousCategoryButton setEnabled:NO];
//        [self.collectionView showLoadingView];
        [self.dataSource changeToPreviousDetailDataSourceWithCompleteHandler:^(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious) {
            if (!error) {
                [self updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
                self.collectionView.dataSource = self.dataSource.activeDetailDataSource;
                [self.collectionView reloadData];
//                [self.collectionView removeLoadingView];
            }else{
                if ([error.domain isEqualToString:MenuScreenError_isFirst]) {
                    [self updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
                    self.collectionView.dataSource = self.dataSource.activeDetailDataSource;
                    [self.collectionView reloadData];
                    [self.nextCategoryButton setEnabled:NO];
                }else{
                    NSLog(@"MenuScreen - Change dataSource failed - Error :%@", error.domain);
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
