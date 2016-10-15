//
//  QRCodeScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "QRCodeScreen.h"
#import "CouponAlertView.h"
#import "UIUtils.h"

@interface QRCodeScreen () <CouponAlertViewDelegate>

@property (weak) IBOutlet UIImageView *QRImage;
@property (weak) IBOutlet UIActivityIndicatorView *indicator;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *couponTitle;
@property (weak, nonatomic) IBOutlet UIButton *useButton;

@end

@implementation QRCodeScreen

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.view layoutIfNeeded];
    _contentView.layer.cornerRadius = 5.0f;
    _useButton.layer.cornerRadius = 5.0f;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_indicator startAnimating];
    
    if (_QRString && ![_QRString isEqualToString:@""]) {
        [self generateQRCode:_QRString];
    }
    
    [_indicator stopAnimating];
    [_indicator setHidden:YES];
}

- (NSString *)title{
    return @"Coupone Detail";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)generateQRCode:(NSString *)qrString{
    
    qrString = @"http://google.com";
    
    NSData *stringData = [qrString dataUsingEncoding: NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    
    float scaleX = _QRImage.frame.size.width / qrImage.extent.size.width;
    float scaleY = _QRImage.frame.size.height / qrImage.extent.size.height;
    
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    _QRImage.image = [UIImage imageWithCIImage:qrImage
                                                 scale:[UIScreen mainScreen].scale
                                           orientation:UIImageOrientationUp];
}

- (IBAction)useCouponTapped:(id)sender {
    CouponAlertView *alertView = [[UIUtils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CouponAlertView class])];
    [alertView showFrom:self.navigationController?self.navigationController:self withType:CouponAlertImageTypeSend title:@"Request use coupon" description:@"40% off Nike Air Max 2.0 edition 2016" positiveButton:@"Request" negativeButton:nil delegate:self];
}

#pragma mark - CouponAlertViewDelegate

- (void)onPositiveButtonTapped:(CouponAlertView *)alertView{
    NSLog(@"CouponAlertView - positive button tapped!");
    [alertView dismissViewControllerAnimated:YES completion:nil];
}

@end
