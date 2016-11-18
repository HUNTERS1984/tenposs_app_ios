//
//  Item_Cell_Top_t2_slide.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_Top_t2_slide.h"
#import "UIImageView+WebCache.h"

@interface Item_Cell_Top_t2_slide ()

@property (weak, nonatomic)IBOutlet UIView *view;

@end

@implementation Item_Cell_Top_t2_slide

- (instancetype)initWithFrame:(CGRect)frame andCoupon:(CouponObject *)coupon{
    self = [super initWithFrame:frame];
    if(self) {
        _coupon = coupon;
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andTopItem:(TopObject *)topObject{
    self = [super initWithFrame:frame];
    if(self) {
        _topObject = topObject;
        self.frame = frame;
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        if ([self.subviews count] == 0) {
            [self setup];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        if ([self.subviews count] == 0) {
            [self setup];
        }
    }
    return self;
}

- (void)setup{
    _view = [self loadViewFromNib];
    _view.frame = self.bounds;
    _view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:_view];
}

- (UIView *)loadViewFromNib{
    
    NSBundle *bundle = [NSBundle mainBundle];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:bundle];
    
    UIView *v = (UIView *)[[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    return v;

}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!_coupon) {
        return;
    }
    
    if (_coupon) {
        [_thumb sd_setImageWithURL:[NSURL URLWithString:_coupon.image_url]];
    }else if (_topObject){
        [_thumb sd_setImageWithURL:[NSURL URLWithString:_topObject.image_url]];
    }
    
//    [_title setText:_coupon.title];
//    [_desc setText:_coupon.desc];
//    [_code setText:_coupon.code];
//    [_thumb sd_setImageWithURL:[NSURL URLWithString:_coupon.image_url]];
}

@end
