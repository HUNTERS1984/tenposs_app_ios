//
//  CouponDetailScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/22/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "CouponDetailScreen.h"
#import "UIViewController+LoadingView.h"
#import "HexColors.h"
#import "QRCodeScreen.h"
#import "UIImageView+WebCache.h"
#import "AppConfiguration.h"
#import "HexColors.h"
#import "Utils.h"

@interface CouponDetailScreen () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *pagerScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *topPageControl;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;
@property (weak, nonatomic) IBOutlet UILabel *couponTitle;
@property (weak, nonatomic) IBOutlet UILabel *couponEndDate;
@property (weak, nonatomic) IBOutlet UIButton *useCouponButton;
@property (weak, nonatomic) IBOutlet UITextView *couponDesciption;
@property (weak, nonatomic) IBOutlet UILabel *hashTag;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeightConstraint;

@property (assign, nonatomic)NSInteger currentTopPageIndex;
@property (strong, nonatomic) NSMutableArray <NSString *> *topArray;

@end

@implementation CouponDetailScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.couponTitle setText:self.coupon.title];

    NSString *couponTypeId = [NSString stringWithFormat:@"ID%ld・%@", (long)_coupon.coupon_id, _coupon.coupon_type.name];
    if (couponTypeId) {
        [self.categoryTitle setText:couponTypeId];
    }
    
    NSString *endDate = [Utils formatDateStringToJapaneseFormat:_coupon.end_date];
    
    if (endDate) {
        [self.couponEndDate setText:[NSString stringWithFormat:@"有効期間　%@まで",endDate]];
    }

    [self.couponDesciption setText:self.coupon.desc];
    self.couponDesciption.textAlignment = NSTextAlignmentJustified;
    NSString *tag = @"";
    if ([self.coupon.taglist count] > 1) {
        tag = [self.coupon.taglist componentsJoinedByString:@" #"];
    } else {
        tag = [NSString stringWithFormat:@"#%@", self.coupon.taglist[0]];
    }
    [self.hashTag setText:tag];
    
    [self showLoadingViewWithMessage:@""];
    
    if (_coupon.can_use) {
        [_useCouponButton setBackgroundColor:[UIColor colorWithHexString:@"#29c9c8"]];
        [_useCouponButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_useCouponButton setTitle:NSLocalizedString(@"take_advantage_of_this_coupon", nil) forState:UIControlStateNormal];
        [_useCouponButton setTitle:NSLocalizedString(@"take_advantage_of_this_coupon", nil) forState:UIControlStateSelected];
        [_useCouponButton setUserInteractionEnabled:YES];
    }else{
        [_useCouponButton setBackgroundColor:[UIColor colorWithHexString:@"#97a1a4"]];
        [_useCouponButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_useCouponButton setTitle:NSLocalizedString(@"this_coupon_cannot_use", nil) forState:UIControlStateNormal];
        [_useCouponButton setTitle:NSLocalizedString(@"this_coupon_cannot_use", nil) forState:UIControlStateSelected];
        [_useCouponButton setUserInteractionEnabled:NO];
    }
    
    if (!_topArray) {
        _topArray = [NSMutableArray new];
    }
    //TODO: need array of images
    [_topArray addObject:_coupon.image_url];
}

- (NSString *)title{
    return self.coupon.title;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationBar *nav = self.navigationController.navigationBar;
    if (nav) {
        AppConfiguration *appConfig = [AppConfiguration sharedInstance];
        AppSettings *settings = [appConfig getAvailableAppSettings];
        
        [nav setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor colorWithHexString:settings.title_color], NSForegroundColorAttributeName,nil]];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CGFloat contentBottom = self.couponDesciption.frame.origin.y;
    CGFloat allHeight = [self.couponDesciption sizeThatFits:CGSizeMake(self.couponDesciption.frame.size.width, CGFLOAT_MAX)].height;
    CGFloat neededHeight = allHeight ;
    self.descriptionHeightConstraint.constant = allHeight;
    self.contentViewHeightConstraint.constant = neededHeight + contentBottom;
    [self.view needsUpdateConstraints];
    [self configureTopScrollView];
    [self removeLoadingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)copyClipboard:(id)sender {
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:self.hashTag.text];
    
    [self showCopiedScreen:YES];
    //[self showSuccess:NSLocalizedString(@"copy_hashtag", nil)];
}

- (void)showCopiedScreen:(BOOL)show{
    if (show) {
        UIView *bg = [[UIView alloc] initWithFrame:self.view.bounds];
        bg.tag = 1997;
        
        [bg setBackgroundColor:[UIColor colorWithHexString:@"263543" alpha:0.75f]];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [img setContentMode:UIViewContentModeScaleAspectFill];
        [img setImage:[UIImage imageNamed:@"icon_copied"]];
        
        [bg addSubview:img];
        
        img.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *centerHor = [NSLayoutConstraint
                                         constraintWithItem:img
                                         attribute:NSLayoutAttributeCenterX
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:bg
                                         attribute:NSLayoutAttributeCenterX
                                         multiplier:1.0
                                         constant:0];
        NSLayoutConstraint *centerVer = [NSLayoutConstraint
                                         constraintWithItem:img
                                         attribute:NSLayoutAttributeCenterY
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:bg
                                         attribute:NSLayoutAttributeCenterY
                                         multiplier:1.0
                                         constant:0];
        NSLayoutConstraint *w = [NSLayoutConstraint
                                 constraintWithItem:img
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:nil
                                 attribute:NSLayoutAttributeWidth
                                 multiplier:1.0
                                 constant:50];
        NSLayoutConstraint *h = [NSLayoutConstraint
                                 constraintWithItem:img
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:nil
                                 attribute:NSLayoutAttributeHeight multiplier:1.0 constant:50];
        [img addConstraint:w];
        [img addConstraint:h];
        
        [bg addConstraint:centerHor];
        [bg addConstraint:centerVer];
        [bg needsUpdateConstraints];
        UILabel *message = [[UILabel alloc] init];
        [message setText:NSLocalizedString(@"hash_tag_copied", nil)];
        [message setTextColor:[UIColor whiteColor]];
        message.backgroundColor = [UIColor clearColor];
        [bg addSubview:message];
        message.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *retryHor = [NSLayoutConstraint
                                        constraintWithItem:message
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:bg
                                        attribute:NSLayoutAttributeCenterX
                                        multiplier:1.0
                                        constant:0];
        NSLayoutConstraint *centerTop = [NSLayoutConstraint
                                         constraintWithItem:message
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:img
                                         attribute:NSLayoutAttributeBottom
                                         multiplier:1.0
                                         constant:16];
        [bg addConstraint:retryHor];
        [bg addConstraint:centerTop];
        [bg needsUpdateConstraints];
        [self.view addSubview:bg];
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [self.view addGestureRecognizer:singleFingerTap];
    }else{
        for (UIView *subView in self.view.subviews) {
            if (subView.tag == 1997) {
                [subView removeFromSuperview];
                return;
            }
        }
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer{
    [self showCopiedScreen:NO];
}

- (void)loadTopPagerContent{
    
}

- (IBAction)useCouponClicked:(id)sender{
    //TODO: show REAL QRCode
    [self performSegueWithIdentifier:@"coupon_qrcode" sender:@"http://google.com"];
    
//    QRCodeScreen *qrScreen = [[UIUtils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([QRCodeScreen class])];
//    qrScreen.QRString = @"http://google.com";
//    
//    [self presentViewController:qrScreen animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"coupon_qrcode"]) {
        QRCodeScreen *qrScreen = (QRCodeScreen *)segue.destinationViewController;
        qrScreen.QRString = @"http://google.com";
        qrScreen.coupon = _coupon;
    }
}

#pragma mark - Configure Top images scrollView

- (void)configureTopScrollView{
    
    if (!self.topArray
        || ![self.topArray isKindOfClass:[NSMutableArray<TopObject *> class]]
        || [self.topArray count] <= 0) {
        return;
    }
    //Build Top cell
    CGFloat cellScreenWidth = _pagerScrollView.bounds.size.width;
    CGFloat cellScreenHeight = _pagerScrollView.bounds.size.height;
    _pagerScrollView.pagingEnabled = YES;
    _pagerScrollView.contentSize = CGSizeMake(cellScreenWidth * [self.topArray count], cellScreenHeight);
    _pagerScrollView.showsHorizontalScrollIndicator = NO;
    _pagerScrollView.showsVerticalScrollIndicator = NO;
    _pagerScrollView.delegate = self;
    
    self.topPageControl.numberOfPages = [self.topArray count];
    self.topPageControl.currentPage = 0;
    
    if (!self.currentTopPageIndex) {
        [self loadPageContent:0];
        if ([_topArray count] > 1) {
            [self loadPageContent:1];
        }
    }else{
        [self loadPageContent:self.currentTopPageIndex];
        self.topPageControl.currentPage = self.currentTopPageIndex;
    }
}

- (void)loadPageContent:(NSInteger)pageIndex{
    if (pageIndex > [self.topArray count]) {
        return;
    }
    
    NSString *image_url = [self.topArray objectAtIndex:pageIndex];
    
    CGRect frame = _pagerScrollView.bounds;
    frame.origin.x = CGRectGetWidth(frame) * pageIndex;
    frame.origin.y = 0;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.backgroundColor = [UIColor lightGrayColor];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    imageView.clipsToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:image_url]];
    
    [_pagerScrollView addSubview:imageView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = CGRectGetWidth(_pagerScrollView.frame);
    NSUInteger page = floor((_pagerScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.topPageControl.currentPage = page;
    self.currentTopPageIndex = page;
}

@end
