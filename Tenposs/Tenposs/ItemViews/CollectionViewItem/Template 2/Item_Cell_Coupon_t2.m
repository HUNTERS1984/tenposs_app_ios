//
//  Item_Cell_Coupon_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_Coupon_t2.h"
#import "UIImageView+WebCache.h"
#import "Utils.h"
#import "HexColors.h"

@implementation Item_Cell_Coupon_t2

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setNeedsLayout];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    _thumb.clipsToBounds = YES;
    _userButton.layer.cornerRadius = 6;
}

- (void)configureCellWithData:(NSObject *)data{
    if (![data isKindOfClass:[CouponObject class]]) {
        return;
    }
    CouponObject *coupon = (CouponObject *)data;
    [_thumb sd_setImageWithURL:[NSURL URLWithString:coupon.image_url]];
    [_couponTitle setText:coupon.title];
    [_couponInfo setText:[NSString stringWithFormat:@"ID%d・%@", coupon.coupon_id, coupon.coupon_type.name]];
    NSString *endDate = [Utils formatDateStringToJapaneseFormat:coupon.end_date];
    
    if (endDate) {
        [_couponDesc setText:[NSString stringWithFormat:@"有効期間　%@まで",endDate]];
    }
    if (coupon.can_use) {
        [_userButton setBackgroundColor:[UIColor colorWithHexString:@"#3CB963"]];
        [_userButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_userButton setTitle:NSLocalizedString(@"take_advantage_of_this_coupon", nil) forState:UIControlStateNormal];
        [_userButton setTitle:NSLocalizedString(@"take_advantage_of_this_coupon", nil) forState:UIControlStateSelected];
        [_userButton setUserInteractionEnabled:YES];
    }else{
        [_userButton setBackgroundColor:[UIColor colorWithHexString:@"#97a1a4"]];
        [_userButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_userButton setTitle:NSLocalizedString(@"this_coupon_cannot_use", nil) forState:UIControlStateNormal];
        [_userButton setTitle:NSLocalizedString(@"this_coupon_cannot_use", nil) forState:UIControlStateSelected];
        [_userButton setUserInteractionEnabled:NO];
    }
    
    [self generateQRCode:coupon.code withImageView:_qrCodeImage];
    
}

-(void)generateQRCode:(NSString *)qrString withImageView:(UIImageView *)QRImage{
    
    NSData *stringData = [qrString dataUsingEncoding: NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    
    float scaleX = QRImage.frame.size.width / qrImage.extent.size.width;
    float scaleY = QRImage.frame.size.height / qrImage.extent.size.height;
    
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    QRImage.image = [UIImage imageWithCIImage:qrImage
                                         scale:[UIScreen mainScreen].scale
                                   orientation:UIImageOrientationUp];
}


+(CGFloat)getCellHeightWithWidth:(CGFloat)width{
    
    CGFloat height = 0;
    
    CGFloat thumbHeight = width/2;
    CGFloat infoHeight = 16;
    CGFloat titleHeight = 21;
    CGFloat descHeight = 18;
    CGFloat qrHeight = 120;
    CGFloat buttonHeight = 44;
    
    height = thumbHeight + 8 + infoHeight + 8 + titleHeight + 8 + descHeight + 15 + qrHeight + 15 + buttonHeight + 8;
    
    return height;
}

@end
