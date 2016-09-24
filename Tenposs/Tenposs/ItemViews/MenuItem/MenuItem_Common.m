//
//  MenuItem_Common.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/27/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "MenuItem_Common.h"
#import "AppConfiguration.h"
#import "HexColors.h"
#import "UIFont+Themify.h"
#import "Utils.h"

@interface MenuItem_Common()

@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UIImageView *itemIconFont;

@end

@implementation MenuItem_Common

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithData:(MenuModel *)data{
    ///Config Layout
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *settings = [appConfig getAvailableAppSettings];
    if (settings.menu_font_family != nil && ![settings.menu_font_family isEqualToString:@""]) {
        [self.itemTitle setFont:[UIFont fontWithName:settings.menu_font_family size:settings.menu_font_size]];
    }else{
        //TODO: need default value
    }
    [self.itemTitle setTextColor:[UIColor colorWithHexString:settings.menu_font_color]];
    if (settings.menu_font_size < 20)
        settings.menu_font_size = 20;
    ///Config data
    if (data != nil) {
        [self.itemTitle setText:data.name];
    }
}

@end
