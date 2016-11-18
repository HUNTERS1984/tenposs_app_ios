//
//  Item_Cell_Top_t2_slide.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"


@interface Item_Cell_Top_t2_slide : UIView

@property (strong, nonatomic) CouponObject *coupon;
@property (strong, nonatomic) TopObject * topObject;

@property (weak, nonatomic)IBOutlet UIImageView *thumb;
@property (weak, nonatomic)IBOutlet UILabel *title;
@property (weak, nonatomic)IBOutlet UILabel *desc;
@property (weak, nonatomic)IBOutlet UILabel *code;
@property (weak, nonatomic)IBOutlet UIButton *useButton;

- (instancetype)initWithFrame:(CGRect)frame andCoupon:(CouponObject *)coupon;

- (instancetype)initWithFrame:(CGRect)frame andTopItem:(TopObject *)topObject;

@end
