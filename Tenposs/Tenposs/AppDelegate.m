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
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginScreen.h"

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
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo)
    {
        [self application:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
    }
    
    if (!_window) {
        _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    
    if ([[UserData shareInstance] getToken]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        SplashScreen *nextController = [storyboard instantiateViewControllerWithIdentifier:@"SplashScreen"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:nextController];
        [navi.navigationBar setHidden:YES];
        [self.window setRootViewController:navi];
    }else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        LoginScreen *nextController = [storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
        [self.window setRootViewController:nextController];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
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
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIRemoteNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge)];
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([[UserData shareInstance] getToken]) {
        [self sendPushToken:token]; // api gui token len server
    }
    NSLog(@"content---%@", token);
}
-(void) sendPushToken:(NSString*)devtoken{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:devtoken forKey:KeyAPI_KEY];
    [params setObject:@"1" forKey:KeyAPI_CLIENT];
    [params setObject:[[UserData shareInstance] getToken] forKey:KeyAPI_TOKEN];
    [[NetworkCommunicator shareInstance] POST:API_SETPUSHKEY parameters:params onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
        if(isSuccess) {
            
        }else{
            
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
//    if ([[Twitter sharedInstance] application:application openURL:url options:options]) {
//        return YES;
//    }
//    
    return handled;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    if ([[Twitter sharedInstance] application:app openURL:url options:options]) {
        return YES;
    }
    
    // If you handle other (non Twitter Kit) URLs elsewhere in your app, return YES. Otherwise
    return NO;
}


-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    //do something here!
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    @try {
        
        // case: push comes after user logs out
        if([[UserData shareInstance] getToken].length == 0)
            return;
        _userInfo = userInfo;
        if (application.applicationState == UIApplicationStateActive) {
            
            if (!self.smallNofiticationView) {
                self.smallNofiticationView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, self.window.bounds.size.width, 64)];
                self.smallNofiticationView.backgroundColor = HEXCOLOR(0x3498db);
                self.smallNofiticationView.opaque = TRUE;
                self.infor = [[UILabel alloc] initWithFrame:CGRectMake(43, 7, self.window.bounds.size.width - 46, 64)];
                self.infor.text = [[[_userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
                self.infor.textColor = [UIColor whiteColor];
                self.infor.font = [UIFont systemFontOfSize:12];
                self.infor.textAlignment = NSTextAlignmentLeft;
                self.infor.numberOfLines = 0;
                self.infor.lineBreakMode = YES;
                [self.smallNofiticationView addSubview:self.infor];
                
                self.avatarIcon = [[UIImageView alloc]initWithFrame:CGRectMake(7, 25, 30, 30)];
                self.avatarIcon.layer.cornerRadius = self.avatarIcon.bounds.size.width/2;
                self.avatarIcon.layer.borderWidth = 1;
                self.avatarIcon.layer.borderColor = [UIColor whiteColor].CGColor;
                self.avatarIcon.clipsToBounds = YES;
                
                NSString *image_url = [[[_userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"image_url"];
                if (image_url != nil )
                    [self.avatarIcon sd_setImageWithURL:[NSURL URLWithString:image_url]];
                else
                    [self.avatarIcon setImage:[UIImage imageNamed:@"user_icon"]];
                [self.smallNofiticationView addSubview:self.avatarIcon];
                
                _customTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapNotificationView:)];
                _customTap.numberOfTapsRequired = 1;
                [self.smallNofiticationView addGestureRecognizer:_customTap];
                
                [self.window addSubview:self.smallNofiticationView];
                self.infor.userInteractionEnabled = YES;
            } else {
                self.infor.text = [[[_userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
                NSString *image_url = [[[_userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"image_url"];
                if (image_url != nil )
                    [self.avatarIcon sd_setImageWithURL:[NSURL URLWithString:image_url]];
                else
                    [self.avatarIcon setImage:[UIImage imageNamed:@"user_icon"]];
            }
            

            [UIView animateWithDuration:1 animations:^{
                [self.smallNofiticationView setFrame:CGRectMake(0, 0, self.window.bounds.size.width, 64)];
                [self.window bringSubviewToFront:self.smallNofiticationView];
                
            }];
            
            double delayInSeconds = 4.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [UIView animateWithDuration:1 animations:^{
                    [self.smallNofiticationView setFrame:CGRectMake(0, -64, self.window.bounds.size.width, 64)];
                    [self.window bringSubviewToFront:self.smallNofiticationView];
                }];
            });
            
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
-(void)handleTapNotificationView:(UITapGestureRecognizer*)customTap{
    [self showPushNotification:_userInfo];
}
- (void) showPushNotification: (NSDictionary *)userInfo {
}


@end
