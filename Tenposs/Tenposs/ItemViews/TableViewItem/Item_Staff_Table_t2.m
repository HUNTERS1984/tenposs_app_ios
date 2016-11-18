//
//  Item_Staff_Table_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Staff_Table_t2.h"
#import "HexColors.h"

@implementation Item_Staff_Table_t2

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setNeedsLayout];
    _avatar.layer.cornerRadius = _avatar.frame.size.width/2;
    _avatar.clipsToBounds = YES;
    _connectButton.layer.cornerRadius = 5;
    _connectButton.layer.borderWidth = 1;
    _connectButton.layer.borderColor = [UIColor colorWithHexString:@"3CB963"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithData:(NSObject *)data{
    if (![data isKindOfClass:[StaffObject class]]) {
        return;
    }
    StaffObject *staff = (StaffObject *)data;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:staff.image_url]];
    [_name setText:staff.name];
    [_title setText:staff.category];
}

+ (CGFloat)getHeightWithWidth:(CGFloat)width{
    return 60;
}

@end
