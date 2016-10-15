//
//  GrandViewController.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/9/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideMenuTableViewController.h"
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, NavigationBarStyle) {
    NavigationBarStyleDefault,
    NavigationBarStyleLight,
    NavigationBarStyleDark
};

@interface GrandViewController : BaseViewController<SideMenuDelegate>

- (void)performSegueWithObject:(NSObject *)object;
- (void)setNavigationBarStyle:(NavigationBarStyle)style;

@end
