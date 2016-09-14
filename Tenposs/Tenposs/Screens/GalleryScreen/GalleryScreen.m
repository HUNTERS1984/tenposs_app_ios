//
//  GalleryScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/21/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "GalleryScreen.h"
#import "GalleryScreenDataSource.h"
#import "UIViewController+LoadingView.h"
#import "PhotoViewer.h"
#import "UIFont+Themify.h"
#import "HexColors.h"
#import "AppConfiguration.h"

@interface GalleryScreen()<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIButton *previousCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *nextCategoryButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;

/// Data source
@property (strong, nonatomic) GalleryScreenDataSource *dataSource;

@end

@implementation GalleryScreen

- (void)loadView{
    [super loadView];
    self.dataSource = [[GalleryScreenDataSource alloc] initAndShouldShowLatest:YES];
    self.dataSource.collectionView = self.collectionView;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *settings = [appConfig getAvailableAppSettings];
    
    [_previousCategoryButton setFont:[UIFont themifyFontOfSize:settings.font_size]];
    [_previousCategoryButton setTitle:[NSString stringWithFormat: [UIFont stringForThemifyIdentifier:@"ti-arrow-left"]] forState:UIControlStateNormal];
    [_nextCategoryButton setFont:[UIFont themifyFontOfSize:settings.font_size]];
    [_nextCategoryButton setTitle:[NSString stringWithFormat: [UIFont stringForThemifyIdentifier:@"ti-arrow-right"]] forState:UIControlStateNormal];

}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.collectionView.delegate = self;
    
    [self showLoadingViewWithMessage:@""];
    __weak GalleryScreen *weakSelf = self;
    [self.dataSource fetchDataWithCompleteHandler:^(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious) {
        if (error) {
            [UIView animateWithDuration:0.5 animations:^{
                [weakSelf removeLoadingView];
                [weakSelf showLoadingViewWithMessage:error.domain?:@"Error"];
            }];
        }else{
            [weakSelf updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
            weakSelf.collectionView.dataSource = weakSelf.dataSource.activeDetailDataSource;
            [weakSelf.collectionView reloadData];
            [weakSelf removeLoadingView];
        }
    }];
}

- (NSString *)title{
    return @"Gallery";
}

#pragma mark - UI methods

- (IBAction)buttonClick:(id)sender {
    if (sender == self.nextCategoryButton) {
        [self.nextCategoryButton setEnabled:NO];
        [self.previousCategoryButton setEnabled:NO];
        //        [self.collectionView showLoadingView];
        __weak GalleryScreen *weakSelf = self;
        [self.dataSource changeToNextDetailDataSourceWithCompleteHandler:^(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious) {
            if (!error) {
                [weakSelf updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
                weakSelf.collectionView.dataSource = weakSelf.dataSource.activeDetailDataSource;
                [weakSelf.collectionView reloadData];
                //                [self.collectionView removeLoadingView];
            }else{
                if(error.code == ERROR_DETAIL_DATASOURCE_IS_LAST){
                    [weakSelf updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
                    weakSelf.collectionView.dataSource = weakSelf.dataSource.activeDetailDataSource;
                    [weakSelf.collectionView reloadData];
                    [weakSelf.nextCategoryButton setEnabled:NO];
                }else{
                    NSLog(@"GalleryScreen - Change dataSource failed - Error :%@", error.domain);
                }
            }
        }];
    }else if(sender == self.previousCategoryButton){
        [self.nextCategoryButton setEnabled:NO];
        [self.previousCategoryButton setEnabled:NO];
        //        [self.collectionView showLoadingView];
        __weak GalleryScreen *weakSelf = self;
        [self.dataSource changeToPreviousDetailDataSourceWithCompleteHandler:^(NSError *error, NSString *detailDataSourceTitle, BOOL hasNext, BOOL hasPrevious) {
            if (!error) {
                [weakSelf updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
                weakSelf.collectionView.dataSource = weakSelf.dataSource.activeDetailDataSource;
                [weakSelf.collectionView reloadData];
                //                [self.collectionView removeLoadingView];
            }else{
                if (error.code == ERROR_DETAIL_DATASOURCE_IS_FIRST) {
                    [weakSelf updateCategoryNavigationWithTitle:detailDataSourceTitle showNext:hasNext showPrevious:hasPrevious];
                    weakSelf.collectionView.dataSource = self.dataSource.activeDetailDataSource;
                    [weakSelf.collectionView reloadData];
                    [weakSelf.previousCategoryButton setEnabled:NO];
                }else{
                    NSLog(@"GalleryScreen - Change dataSource failed - Error :%@", error.domain);
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

#pragma mark - Public methods

- (void)showPhoto:(PhotoObject *)photoObject{
    [self performSegueWithIdentifier:@"gallery_photo_viewer" sender:photoObject];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"gallery_photo_viewer"]) {
        PhotoViewer *viewer = (PhotoViewer *)segue.destinationViewController;
        [viewer setPhoto:(PhotoObject *)sender];
    }
}

#pragma mark - Communicator

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *item = [self.dataSource itemAtIndexPath:indexPath];
    if ([item isKindOfClass:[PhotoObject class]]) {
        PhotoObject *photo = (PhotoObject *)item;
        if (photo) {
            [self showPhoto:photo];
        }
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
