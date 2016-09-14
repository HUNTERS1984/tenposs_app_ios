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
#import <SDWebImage/UIImageView+WebCache.h>

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
@property (weak, nonatomic) IBOutlet UILabel *hashTag;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeightConstraint;
@end

@implementation CouponDetailScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _pagerScrollView.frame.size.width/2, _pagerScrollView.frame.size.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.coupon.image_url]];
    [_pagerScrollView addSubview:imageView];
    
    [self.couponTitle setText:self.coupon.title];
    [self.categoryTitle setText:self.coupon.coupon_type.name];
    [self.couponEndDate setText:[NSString stringWithFormat:@"有効期間　%@",self.coupon.end_date]];
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
    
    if (_coupon.can_use == COUPON_STATUS_AVAILABLE) {
        [_useCouponButton setBackgroundColor:[UIColor colorWithHexString:@"#29c9c8"]];
        [_useCouponButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_useCouponButton setTitle:NSLocalizedString(@"use_coupon", nil) forState:UIControlStateNormal];
        [_useCouponButton setTitle:NSLocalizedString(@"use_coupon", nil) forState:UIControlStateSelected];
    }else{
        [_useCouponButton setBackgroundColor:[UIColor colorWithHexString:@"#97a1a4"]];
        [_useCouponButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_useCouponButton setTitle:NSLocalizedString(@"unable_use_coupon", nil) forState:UIControlStateNormal];
        [_useCouponButton setTitle:NSLocalizedString(@"unable_use_coupon", nil) forState:UIControlStateSelected];
        [_useCouponButton setUserInteractionEnabled:NO];
    }
}

- (NSString *)title{
    return self.coupon.title;
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
- (IBAction)copyClipboard:(id)sender {
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:self.hashTag.text];
    [self showSuccess:NSLocalizedString(@"copy_hashtag", nil)];
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
