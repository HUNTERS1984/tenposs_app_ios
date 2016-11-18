//
//  Item_Cell_Coupon_t2.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common_Item_Cell.h"

@interface Item_Cell_Coupon_t2 : Common_Item_Cell

@property (weak, nonatomic) IBOutlet UIImageView *thumb;
@property (weak, nonatomic) IBOutlet UILabel *couponInfo;
@property (weak, nonatomic) IBOutlet UILabel *couponTitle;
@property (weak, nonatomic) IBOutlet UILabel *couponDesc;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImage;
@property (weak, nonatomic) IBOutlet UIButton *userButton;

@end
