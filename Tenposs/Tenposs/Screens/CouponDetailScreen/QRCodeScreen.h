//
//  QRCodeScreen.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DataModel.h"

@interface QRCodeScreen : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSString * QRString;
@property (strong, nonatomic) CouponObject *coupon;
@end
