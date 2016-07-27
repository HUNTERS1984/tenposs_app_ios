//
//  MenuItem_User.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/26/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "MenuItem_User.h"
#import "AppConfiguration.h"

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
    [self.user_name setFont:[UIFont fontWithName:appConfig.menuFontFamily size:appConfig.menuTextSize]];
    [self.user_name setTextColor:appConfig.menuTextColor];
    
    
    ///Config Avatar
    
}

@end
