//
//  Item_Cell_Staff_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_Staff_t2.h"
#import "UIImageView+WebCache.h"

@implementation Item_Cell_Staff_t2

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setNeedsLayout];
    _avatar.clipsToBounds = YES;
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowRadius = 3;
}

- (void)configureCellWithData:(NSObject *)data{
    if(![data isKindOfClass:[StaffObject class]]){
        return;
    }
    StaffObject *staff = (StaffObject *)data;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:staff.image_url]];
    [_name setText:staff.name];
    [_title setText:staff.staff_categories.name];
}

+ (CGFloat)getCellHeightWithWidth:(CGFloat)width{
    CGFloat imageHeight = width - 2*2;
    CGFloat nameHeight = 20;
    CGFloat titleHeight = 18;
    CGFloat height = imageHeight + 8 + nameHeight + 8 + titleHeight + 8;
    return height;
}

@end
