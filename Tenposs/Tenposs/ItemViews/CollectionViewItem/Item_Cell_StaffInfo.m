//
//  Item_Cell_Coupon.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/22/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_StaffInfo.h"
#import "DataModel.h"
#import "UIImageView+WebCache.h"

@interface Item_Cell_StaffInfo()
@property (weak, nonatomic) IBOutlet UILabel *staff_gender;
@property (weak, nonatomic) IBOutlet UILabel *staff_price;
@property (weak, nonatomic) IBOutlet UILabel *staff_tel;

@end

@implementation Item_Cell_StaffInfo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(NSObject *)data{
    StaffObject *staff = (StaffObject *)data;
    if (staff) {
        [_staff_gender setText:[staff.gender isEqualToString:@"0"] ? NSLocalizedString(@"gender_male",nil) : NSLocalizedString(@"gender_female",nil)];
        [_staff_price setText:staff.price];
        [_staff_tel setText:staff.tel];
    }
}


+ (CGFloat)getCellHeightWithWidth:(CGFloat)width{
    return 140;
}

@end
