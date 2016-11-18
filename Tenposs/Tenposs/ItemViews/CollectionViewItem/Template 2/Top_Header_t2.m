//
//  Top_Header_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Top_Header_t2.h"
#import "AppConfiguration.h"


@implementation Top_Header_t2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureHeaderWithMenuId:(NSInteger)menuId{
    NSString *imageName = @"";
    NSString *title = @"";
    if (menuId == APP_MENU_NEWS) {
        imageName = @"t2_icon_news";
        title = @"ニュース";
    }
    [_icon setImage:[UIImage imageNamed:imageName]];
    [_title setText:title];
}

- (IBAction)headerTapped:(id)sender {
    
}

@end
