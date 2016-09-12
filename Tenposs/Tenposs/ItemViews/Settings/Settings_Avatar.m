//
//  Settings_Avatar.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/11/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Settings_Avatar.h"

@interface Settings_Avatar()


@end

@implementation Settings_Avatar

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCellWithData:(NSObject *)data{
    if ([data isKindOfClass:[NSString class]]) {
        [_avatar setImage:[UIImage imageNamed:@"user_icon"]];
    }
}

+(CGFloat)height{
    return 88;
}

@end
