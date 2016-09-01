//
//  MenuItem_User.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/26/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "MenuItem_User.h"
#import "AppConfiguration.h"
#import "HexColors.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MenuItem_User()

@property (weak, nonatomic) IBOutlet UIImageView *user_avatar;
@property (weak, nonatomic) IBOutlet UILabel *user_name;

@end

@implementation MenuItem_User

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithData:(UserModel *)data{
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *settings = [appConfig getAvailableAppSettings];
    
    ///Config user name
    [self.user_name setFont:[UIFont fontWithName:settings.menu_font_family size:settings.menu_font_size]];
    [self.user_name setTextColor:[UIColor colorWithHexString:settings.menu_font_color]];
    
    ///Config Avatar
    _user_avatar.layer.cornerRadius = _user_avatar.bounds.size.width/2;
    _user_avatar.layer.borderWidth = 1;
    _user_avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _user_avatar.clipsToBounds = YES;
    
    if (data == nil) {
        [_user_avatar setImage:[UIImage imageNamed:@"user_icon"]];
    }
    if (data.profile.avatar_url == nil || [data.profile.avatar_url isEqualToString:@""]) {
        [_user_avatar setImage:[UIImage imageNamed:@"user_icon"]];
    }else{
        [_user_avatar sd_setImageWithURL:[NSURL URLWithString:(data.profile.avatar_url)] placeholderImage:[UIImage imageNamed:@"user_icon"]];
    }
}

@end
