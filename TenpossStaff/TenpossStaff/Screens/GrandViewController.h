//
//  GrandViewController.h
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/12/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NavigationBarStyle) {
    NavigationBarStyleDefault,
    NavigationBarStyleLight,
    NavigationBarStyleDark
};

@interface GrandViewController : UIViewController

- (void)setNavigationBarStyle:(NavigationBarStyle)style;

@end
