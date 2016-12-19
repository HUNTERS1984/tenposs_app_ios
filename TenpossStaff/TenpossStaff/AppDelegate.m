//
//  AppDelegate.m
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/12/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import "AppDelegate.h"
#import "UserData.h"
#import "CouponAlertView.h"
#import "LoginScreen.h"
#import "MainNavigationController.h"
#import "MFSideMenu.h"
#import "Utils.h"
#import "NetworkCommunicator.h"
#import "PushNotificationManager.h"


@interface AppDelegate ()

@property (strong, nonatomic) NSDictionary *userInfo;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo){
        [self application:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
    }
    
    if (!_window) {
        _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    
    if ([[UserData shareInstance] getToken]) {
        //TODO: user already logged in
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        LoginScreen *nextController = [storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
        [self.window setRootViewController:nextController];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)registerPushNotification{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIRemoteNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge)];
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //TODO: send token back to server
    
    if ([[UserData shareInstance] getToken]) {
        [self sendPushToken:token]; // api gui token len server
    }
    
    NSLog(@"content---%@", token);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"NOTI - failed to register");
}

-(void) sendPushToken:(NSString*)devtoken{
    [[PushNotificationManager sharedInstance] PushStaffSetPushKey:devtoken WithCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
        if(isSuccess) {
            
        }else{
            
        }
    }];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    @try {
        
        // case: push comes after user logs out
        if([[UserData shareInstance] getToken].length == 0)
            return;
        
        _userInfo = userInfo;
        if (application.applicationState == UIApplicationStateActive) {
            
            //TODO: Check for notification type
            
            //TODO: show request coupon popup
            CouponAlertView *alert = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CouponAlertView class])];
            UIViewController *vc = [self topMostViewController];
            
            [alert showFrom:vc withType:CouponAlertImageTypeSend title:@"Request use coupon" description:@"40% off Nike Air Max 2.0 edition 2016" positiveButton:@"Accept" negativeButton:@"Reject" delegate:nil];
            
        } else if (application.applicationState == UIApplicationStateInactive) {
            [self showPushNotification:_userInfo];
        } else if (application.applicationState == UIApplicationStateBackground) {
            [self showPushNotification:_userInfo];
        }
    }
    @catch (NSException *exception) {
        // do nothing
    }
    @finally {
        // do nothing
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    @try {
        
        // case: push comes after user logs out
        if([[UserData shareInstance] getToken].length == 0)
            return;
        
        _userInfo = userInfo;
        if (application.applicationState == UIApplicationStateActive) {
            
            //TODO: Check for notification type
            
            //TODO: show request coupon popup
            CouponAlertView *alert = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CouponAlertView class])];
            UIViewController *vc = [self topMostViewController];
            
            [alert showFrom:vc withType:CouponAlertImageTypeSend title:@"Request use coupon" description:@"40% off Nike Air Max 2.0 edition 2016" positiveButton:@"Accept" negativeButton:@"Reject" delegate:nil];
            
        } else if (application.applicationState == UIApplicationStateInactive) {
            [self showPushNotification:_userInfo];
        } else if (application.applicationState == UIApplicationStateBackground) {
            [self showPushNotification:_userInfo];
        }
    }
    @catch (NSException *exception) {
        // do nothing
    }
    @finally {
        // do nothing
    }
}

- (void) showPushNotification: (NSDictionary *)userInfo {

}

#pragma mark - Helper methods

- (UIViewController *)topMostViewController{
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}


@end
