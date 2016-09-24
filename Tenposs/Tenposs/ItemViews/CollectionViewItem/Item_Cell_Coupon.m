//
//  Item_Cell_Coupon.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/22/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_Coupon.h"
#import "DataModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface Item_Cell_Coupon()
@property (weak, nonatomic) IBOutlet UIView *coupon_thumbnail_boundary;
@property (weak, nonatomic) IBOutlet UILabel *coupon_store;
@property (weak, nonatomic) IBOutlet UILabel *coupon_title;
@property (weak, nonatomic) IBOutlet UIImageView *coupon_thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *coupon_description;

@end

@implementation Item_Cell_Coupon

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(NSObject *)data{
    CouponObject *coupon = (CouponObject *)data;
    if (coupon) {
        [_coupon_store setText:coupon.coupon_type.name];
        [_coupon_title setText:coupon.title];
        [_coupon_description setText:coupon.desc];
        [_coupon_thumbnail sd_setImageWithURL:[NSURL URLWithString:coupon.image_url]];
        _coupon_thumbnail.layer.masksToBounds = YES;
        
        _coupon_thumbnail_boundary.layer.masksToBounds = NO;
        _coupon_thumbnail_boundary.layer.shadowColor = [UIColor blackColor].CGColor;
        _coupon_thumbnail_boundary.layer.shadowOffset = CGSizeMake(1, 1);
        _coupon_thumbnail_boundary.layer.shadowOpacity = 0.2;
        _coupon_thumbnail_boundary.layer.shadowRadius = 0.7;

    }
}


+ (CGFloat)getCellHeightWithWidth:(CGFloat)width{
    CGFloat sideEdgeSpacing = 8 * 2;
    CGFloat topBotSpacing = 8*2;
    CGFloat imageHeight = (width - sideEdgeSpacing) /3;
    
    return imageHeight + topBotSpacing;
}

@end
