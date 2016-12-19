//
//  MainNavigationController.h
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/12/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainNavigationController : UINavigationController

@property (strong, nonatomic) UIViewController *rootViewController;

- (void)toogleMenu;

@end
