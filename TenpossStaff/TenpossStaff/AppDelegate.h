//
//  AppDelegate.h
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/12/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "CouponAlertView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate,CouponAlertViewDelegate>
@property (strong, nonatomic) NSDictionary *userInfo;
@property (strong, nonatomic) UIWindow *window;

- (void)registerPushNotification;

@end

