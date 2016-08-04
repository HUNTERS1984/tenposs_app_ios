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

@interface MenuItem_Common()

@property (weak, nonatomic) IBOutlet UIImageView *itemIcon;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;


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

- (void)configureCellWithData:(NSObject *)data{
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    
    ///Config Text
    [self.itemTitle setFont:[UIFont fontWithName:appConfig.appSettings.menu_font_family size:appConfig.appSettings.menu_font_size]];
    [self.itemTitle setTextColor:[UIColor colorWithHexString:appConfig.appSettings.menu_font_color]];
    
    ///Config Icon
    
}

@end
