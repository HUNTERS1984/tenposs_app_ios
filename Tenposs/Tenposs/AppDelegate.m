//
//  AppDelegate.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/26/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "AppDelegate.h"
#import "AppConfiguration.h"
//#import "GMSServices.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Utils.h"
#import "UserData.h"
#import "NetworkCommunicator.h"
#import "SplashScreen.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>
#import "UIImageView+WebCache.h"

#import "PushNotificationManager.h"
#import "GlobalMapping.h"

#import "SVProgressHUD.h"

#import "Reachability.h"

@interface AppDelegate ()
@property UIView *loadingView;
@property (strong, nonatomic) UIView *smallNofiticationView;
@property (strong, nonatomic) UILabel *infor;
@property (strong, nonatomic) UIImageView *avatarIcon;
@property (strong, nonatomic) NSDictionary *userInfo;
@property (strong,nonatomic) UITapGestureRecognizer *customTap;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyBfiFffrkztj8i920-blC-QXA0Ix-6CLyM"];
  //  [self loadAppConfig];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [[Twitter sharedInstance] startWithConsumerKey:@"qY0dnYDqh99zztg8gBWkLIFrm" consumerSecret:@"Byy6PCW51zvhVrDZayLm8PhenqkHXiRIqLMpK7A5H5XNEzlKYi"];
    [Fabric with:@[[Twitter class]]];
    
    [self loadAppConfig];
    
    if ([[UserData shareInstance] getToken])
        [self registerPushNotification];
        
    if (!_window) {
        _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    
    UIViewController *infoViewController = [[UIViewController alloc] init];
    
    [self.window setRootViewController:infoViewController];
    
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfile:) name:NOTI_USER_PROFILE_REQUEST object:nil];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    return YES;
}

- (void)updateProfile:(NSNotification *)notification{
    if([notification.userInfo objectForKey:@"status"]){
        NSString *status = [notification.userInfo objectForKey:@"status"];
        if ([status isEqualToString:@"failed"]) {
            UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"プロフィールを編集できません" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [failAlert show];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
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


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    //register to receive notifications
    [application registerForRemoteNotifications];
    
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([[UserData shareInstance] getToken]) {
        [self sendPushToken:token]; // api gui token len server
    }
    NSLog(@"content---%@", token);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Failed to register Push notification with error: %@", error);
}

-(void) sendPushToken:(NSString*)devtoken{
    [[PushNotificationManager sharedInstance] PushUserSetPushKey:devtoken WithCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
        if(isSuccess){
            NSLog(@"PUSH - Successfully set push key for user!");
        }else{
            NSLog(@"PUSH - Failed to set push key for user!");
        }
    }];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    return handled;
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
        CouponAlertImageType type = CouponAlertImageTypeAccepted;
        NSString *str = @"クーポン使用を承認されました";
        if ([[data objectForKey:@"action"] isEqualToString:@"reject"]) {
            type = CouponAlertImageTypeRejected;
            str = @"クーポンの使用が拒否されました";
        }
        
        
        CouponAlertView *alert = [[UIStoryboard storyboardWithName:@"Main" bundle: nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CouponAlertView class])];
        [alert showFrom:vc withType:type title:@"クーポン利用のリクエスト" description: str positiveButton:@"閉じる" negativeButton:nil delegate:self];
    }
    
}

- (void)onPositiveButtonTapped:(CouponAlertView *)alertView{
    [alertView dismissViewControllerAnimated:YES completion:nil];
    
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
        CouponAlertImageType type = CouponAlertImageTypeAccepted;
        NSString *str = @"クーポン使用を承認されました";
        if ([[data objectForKey:@"action"] isEqualToString:@"reject"]) {
            type = CouponAlertImageTypeRejected;
            str = @"クーポンの使用が拒否されました";
        }
        
        CouponAlertView *alert = [[UIStoryboard storyboardWithName:@"Main" bundle: nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CouponAlertView class])];
        [alert showFrom:vc withType:type title:@"クーポン利用のリクエスト" description: str positiveButton:@"閉じる" negativeButton:nil delegate:self];
    }
    
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    if ([[Twitter sharedInstance] application:app openURL:url options:options]) {
        return YES;
    }
    if([url absoluteString]){
        if ([[url absoluteString] hasPrefix:@"fb"]) {
            BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:app
                                                                          openURL:url
                                                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                            ];
            return handled;
        }
    }
    return NO;
}

- (void)showScreenWithType:(NSString *)noti_type{
    
}

- (void) showPushNotification: (NSDictionary *)userInfo {
}

- (void)loadAppConfig{
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    
    [appConfig loadAppInfoWithCompletionHandler:^(NSError *error) {
        if ([[UserData shareInstance] getToken] && [[UserData shareInstance] getUserData]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            SplashScreen *nextController = [storyboard instantiateViewControllerWithIdentifier:@"SplashScreen"];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:nextController];
            [navi.navigationBar setHidden:YES];
            [self.window setRootViewController:navi];
            [self.window makeKeyAndVisible];
        }else{
            UIViewController *login = [GlobalMapping getLoginScreenWithNavigation];
            [self.window setRootViewController:login];
            [self.window makeKeyAndVisible];
        }
    }];
}

- (UIViewController *)topMostViewController{
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}


@end
