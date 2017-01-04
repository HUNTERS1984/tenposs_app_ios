//
//  AppDelegate.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/26/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "CouponAlertView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate,CouponAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)registerPushNotification;

@end

