//
//  Settings_Avatar_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/16/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Settings_Avatar_t2.h"
#import "UIImageView+WebCache.h"

@implementation Settings_Avatar_t2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCellWithData:(NSObject *)data{
    if (![data isKindOfClass:[NSString class]]) {
        [_avatar setImage:[UIImage imageNamed:@"user_icon"]];
    }else{
        [_avatar sd_setImageWithURL:[NSURL URLWithString:(NSString *)data]];
    }
}

+(CGFloat)height{
    return 88;
}

@end
