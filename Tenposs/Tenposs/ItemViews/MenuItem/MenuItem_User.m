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

- (void)configureCellWithData:(NSObject *)data{
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    
    ///Config user name
    [self.user_name setFont:[UIFont fontWithName:appConfig.appSettings.menu_font_family size:appConfig.appSettings.menu_font_size]];
    [self.user_name setTextColor:[UIColor colorWithHexString:appConfig.appSettings.menu_font_color]];
    
    
    ///Config Avatar
    
}

@end
