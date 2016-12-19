//
//  Item_Coupon_Request.m
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/14/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import "Item_Coupon_Request.h"
#import "UIImageView+WebCache.h"

@interface Item_Coupon_Request()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *rightInfo;

@end

@implementation Item_Coupon_Request

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    _image.layer.cornerRadius = _image.frame.size.width/2;
    _image.clipsToBounds = YES;
}

- (void)configureCellWithData:(NSObject *)data{
    if ([data isKindOfClass:[CouponRequestModel class]]) {
        CouponRequestModel *request = (CouponRequestModel *)data;
        [_title setText:request.name];
        [_desc setText:request.title];
        [_rightInfo setText:[Utils relativeDateStringForDate:[request getRequestDate]]];
        [_image sd_setImageWithURL:[NSURL URLWithString:request.image_url ]];
    }
}

@end
