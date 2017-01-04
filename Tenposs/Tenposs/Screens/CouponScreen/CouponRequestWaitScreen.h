//
//  CouponRequestWaitScreen.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/16/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "BaseViewController.h"

@interface CouponRequestWaitScreen : BaseViewController

@property (strong, nonatomic) CouponObject *coupon;
@property (strong, nonatomic) StaffObject *staff;

@property(weak, nonatomic)IBOutlet UIImageView *avatar;
@property(weak, nonatomic)IBOutlet UIButton *OKButton;
@property (weak, nonatomic) IBOutlet UIView *circleView1;
@property (weak, nonatomic) IBOutlet UIView *circleView2;
@property (weak, nonatomic) IBOutlet UIView *circleView3;

@end
