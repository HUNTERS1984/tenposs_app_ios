//
//  AppDelegate.m
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/12/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import "AppDelegate.h"
#import "UserData.h"
#import "LoginScreen.h"
#import "MainNavigationController.h"
#import "MFSideMenu.h"
#import "Utils.h"
#import "NetworkCommunicator.h"
#import "PushNotificationManager.h"
#import "Const.h"
#import "Utils.h"
#import "GrandViewController.h"
#import "SideMenuViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (!_window) {
        _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    
    if ([[UserData shareInstance] getToken]) {
        [self registerPushNotification];
        GrandViewController *rootViewController = [[Utils mainStoryboard]instantiateViewControllerWithIdentifier:NSStringFromClass([GrandViewController class])];
        MainNavigationController *mainNavigation = [[MainNavigationController alloc]initWithRootViewController:rootViewController];
        SideMenuViewController *sideMenu = [[Utils mainStoryboard]instantiateViewControllerWithIdentifier:NSStringFromClass([SideMenuViewController class])];//[[SideMenuViewController alloc] init];
        MFSideMenuContainerViewController *viewController = [MFSideMenuContainerViewController
                                                             containerWithCenterViewController:mainNavigation
                                                             leftMenuViewController:sideMenu
                                                             rightMenuViewController:nil];
        
        sideMenu.delegate = (id<SideMenuDelegate>)mainNavigation.rootViewController;
        
        [viewController setModalPresentationStyle:UIModalPresentationCustom];
        viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.window setRootViewController:viewController];
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
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    } else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
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

//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
    
    if([[UserData shareInstance] getToken].length == 0)
        return;
    
    _userInfo = notification.request.content.userInfo;

    UIViewController *vc = [self topMostViewController];
    NSMutableDictionary *data = [_userInfo objectForKey:@"data"];
    if (data != nil) {
        CouponRequestModel *request = [CouponRequestModel alloc];
        request.coupon_id = [[data objectForKey:@"coupon_id"] integerValue];
        request.code = [data objectForKey:@"code"];
        request.app_user_id = [[data objectForKey:@"app_user_id"] integerValue];
        request.title = [[_userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        CouponAlertView *alert = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CouponAlertView class])];
        alert.coupon = request;
        [alert showFrom:vc withType:CouponAlertImageTypeSend title:@"クーポン利用のリクエスト" description:request.title positiveButton:@"同意する" negativeButton:@"同意しない" delegate:self];
    }

}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    completionHandler();
    
    if([[UserData shareInstance] getToken].length == 0)
        return;
    
    _userInfo = response.notification.request.content.userInfo;

    UIViewController *vc = [self topMostViewController];
    NSMutableDictionary *data = [_userInfo objectForKey:@"data"];
    if (data != nil) {
        CouponRequestModel *request = [CouponRequestModel alloc];
        request.coupon_id = [[data objectForKey:@"coupon_id"] integerValue];
        request.code = [data objectForKey:@"code"];
        request.app_user_id = [[data objectForKey:@"app_user_id"] integerValue];
        request.title = [[_userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        CouponAlertView *alert = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CouponAlertView class])];
        alert.coupon = request;
        [alert showFrom:vc withType:CouponAlertImageTypeSend title:@"クーポン利用のリクエスト" description:request.title positiveButton:@"同意する" negativeButton:@"同意しない" delegate:self];
    }

}


- (void) showPushNotification: (NSDictionary *)userInfo {

}

- (void)onPositiveButtonTapped:(CouponAlertView *)alertView{
    //TODO: send accept request
    if (alertView.coupon) {
        NSMutableDictionary * params = [NSMutableDictionary new];
        [params setObject:@"approve" forKey:KeyAPI_ACTION];
        [params setObject:[@(alertView.coupon.coupon_id) stringValue] forKey:KeyAPI_COUPON_ID];
        [params setObject:APP_ID forKey:KeyAPI_APP_ID];
        [params setObject:alertView.coupon.code forKey:KeyAPI_COUPON_CODE];
        
        [[NetworkCommunicator shareInstance] POSTNoParams:API_COUPON_ACCEPT parameters:params onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
            if(isSuccess){
                [self showAlertView:@"情報" message:@"承認しました"];
            }else{
                [self showAlertView:@"エラー" message:@"承認できませんでした"];
            }
        }];
    }
    
    [alertView dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)onNegativeButtonTapped:(CouponAlertView *)alertView{
    
    if (alertView.coupon) {
        NSMutableDictionary * params = [NSMutableDictionary new];
        [params setObject:@"reject" forKey:KeyAPI_ACTION];
        [params setObject:[@(alertView.coupon.coupon_id) stringValue] forKey:KeyAPI_COUPON_ID];
        [params setObject:APP_ID forKey:KeyAPI_APP_ID];
        [params setObject:alertView.coupon.code forKey:KeyAPI_COUPON_CODE];
        
        [[NetworkCommunicator shareInstance] POSTNoParams:API_COUPON_ACCEPT parameters:params onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
            if(isSuccess){
                [self showAlertView:@"情報" message:@"同意しない"];
            }
        }];
    }
    
    [alertView dismissViewControllerAnimated:YES completion:nil];
}

-(void)showAlertView:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"閉じる"
                                          otherButtonTitles:nil];
    [alert show];
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
