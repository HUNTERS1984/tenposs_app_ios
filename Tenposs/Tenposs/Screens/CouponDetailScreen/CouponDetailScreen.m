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

@interface CouponDetailScreen ()
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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeightConstraint;
@end

@implementation CouponDetailScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.couponTitle setText:_coupon.title];
    [self.categoryTitle setText:@"Category"];
    [self.couponEndDate setText:@"Thursday, August 30, 2016"];
    [self.couponDesciption setText:_coupon.desc];
    self.couponDesciption.textAlignment = NSTextAlignmentJustified;
    [self showLoadingViewWithMessage:@""];
    
    if (_coupon.status == COUPON_STATUS_AVAILABLE) {
        [_useCouponButton setBackgroundColor:[UIColor colorWithHexString:@"#29c9c8"]];
        [_useCouponButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_useCouponButton setTitle:NSLocalizedString(@"use_coupon", nil) forState:UIControlStateNormal];
        [_useCouponButton setTitle:NSLocalizedString(@"use_coupon", nil) forState:UIControlStateSelected];
    }else{
        [_useCouponButton setBackgroundColor:[UIColor colorWithHexString:@"#97a1a4"]];
        [_useCouponButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_useCouponButton setTitle:NSLocalizedString(@"unable_use_coupon", nil) forState:UIControlStateNormal];
        [_useCouponButton setTitle:NSLocalizedString(@"unable_use_coupon", nil) forState:UIControlStateSelected];
    }
}

- (NSString *)title{
    return @"Coupons Title";
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CGFloat contentBottom = self.couponDesciption.frame.origin.y;
    CGFloat allHeight = [self.couponDesciption sizeThatFits:CGSizeMake(self.couponDesciption.frame.size.width, CGFLOAT_MAX)].height;
    CGFloat neededHeight = allHeight ;
    self.descriptionHeightConstraint.constant = allHeight;
    self.contentViewHeightConstraint.constant = neededHeight + contentBottom;
    [self.view needsUpdateConstraints];
    [self removeLoadingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadTopPagerContent{
    
}

- (IBAction)useCouponClicked:(id)sender{
    //TODO: show QRCode
    [self performSegueWithIdentifier:@"coupon_qrcode" sender:@"http://google.com"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"coupon_qrcode"]) {
        QRCodeScreen *qrScreen = (QRCodeScreen *)segue.destinationViewController;
        qrScreen.QRString = @"http://google.com";
    }
}

@end
