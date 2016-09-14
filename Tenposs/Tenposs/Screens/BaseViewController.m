//
//  BaseViewController.m
//  Tenposs
//
//  Created by Luong Hong Quan on 9/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "BaseViewController.h"
#import "UserData.h"
#import "LoginScreen.h"
#import "SplashScreen.h"
#import "SVProgressHUD.h"
#import "NetworkCommunicator.h"
#import "UIFont+Themify.h"
#import "HexColors.h"

@interface BaseViewController () {
    __weak id<NSObject> observer;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *settings = [appConfig getAvailableAppSettings];
    if ([[self.navigationController viewControllers] count] > 1) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                        style:UIBarButtonItemStylePlain target:self action:@selector(didPressBackButton)];
        self.navigationItem.leftBarButtonItem = backButton;
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.navigationItem setBackBarButtonItem:nil];
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIFont themifyFontOfSize:settings.font_size], NSFontAttributeName,
                                                                   [UIColor colorWithHexString:settings.title_color], NSForegroundColorAttributeName,
                                                                   nil]
                                                         forState:UIControlStateNormal];
        [self.navigationItem.leftBarButtonItem setTitle:[NSString stringWithFormat: [UIFont stringForThemifyIdentifier:@"ti-angle-left"]]];
    }
}

- (void)didPressBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Keyboard Notifications
- (void) subscribeForKeyboardWillShowNotificationUsingBlock:(void (^)(NSNotification *note))block {
    
    [self subscribeForKeyboardNotification:UIKeyboardWillShowNotification
                                usingBlock:block];
}

- (void) subscribeForKeyboardWillChangeFrameNotificationUsingBlock:(void (^)(NSNotification *note))block {
    
    [self subscribeForKeyboardNotification:UIKeyboardWillChangeFrameNotification
                                usingBlock:block];
}

-(void)subscribeForKeyboardDidShowNotificationUsingBlock:(void (^)(NSNotification *))block{
    [self subscribeForKeyboardNotification:UIKeyboardDidShowNotification
                                usingBlock:block];
}

- (void) subscribeForKeyboardWillHideNotificationUsingBlock:(void (^)(NSNotification *note))block {
    
    [self subscribeForKeyboardNotification:UIKeyboardWillHideNotification
                                usingBlock:block];
}
- (void) subscribeForKeyboardDidHideNotificationUsingBlock:(void (^)(NSNotification *note))block{
    [self subscribeForKeyboardNotification:UIKeyboardDidHideNotification usingBlock:block];
}
-(void)subscribeForKeyboardDidChangeFrameNotificationUsingBlock:(void (^)(NSNotification *))block{
    [self subscribeForKeyboardNotification:UIKeyboardDidChangeFrameNotification usingBlock:block];
}

- (void) unsubscribeForKeyboardWillShowNotification {
    
    [self unsubscribeForNotificationWithName:UIKeyboardWillShowNotification];
}
- (void) unsubscribeForKeyboardDidShowNotification{
    [self unsubscribeForNotificationWithName:UIKeyboardDidShowNotification];
}

- (void) unsubscribeForKeyboardWillChangeFrameNotification {
    
    [self unsubscribeForNotificationWithName:UIKeyboardWillChangeFrameNotification];
}

- (void) unsubscribeForKeyboardWillHideNotification {
    
    [self unsubscribeForNotificationWithName:UIKeyboardWillHideNotification];
}
-(void)unsubscribeForKeyboardDidHideNotification{
    [self unsubscribeForNotificationWithName:UIKeyboardDidHideNotification];
}

#pragma mark - Notifications Subscribing And Unsubscribing

- (void) subscribeForKeyboardNotification:(const NSString *)notificationName
                               usingBlock:(void (^)(NSNotification *note))block {
    observer = [[NSNotificationCenter defaultCenter] addObserverForName:(NSString *)notificationName
                                                                 object:nil
                                                                  queue:[NSOperationQueue mainQueue]
                                                             usingBlock:block];
}

- (void) unsubscribeForNotificationWithName:(const NSString *)notificationName {
    
    [[NSNotificationCenter defaultCenter] removeObserver:observer
                                                    name:(NSString *)notificationName
                                                  object:nil];
}


#pragma mark

-(void)showLoadingView{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
}
-(void)hideLoadingView{
    [SVProgressHUD dismiss];
}

-(void)showSuccess:(NSString*)str{
    [SVProgressHUD showSuccessWithStatus:str];
}

-(void)showError:(NSString*)str{
    [SVProgressHUD showErrorWithStatus:str];
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:str delegate:nil cancelButtonTitle:@"閉じる" otherButtonTitles:nil];
    //    [alert show];
}

-(void)showAlertView:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"閉じる" otherButtonTitles:nil];
    [alert show];
}


-(void)showLogin{
    if (![[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[LoginScreen class]])
    {
//        if ([[UserData shareInstance] SignOut]) {
//            
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//            LoginViewcontroller *nextController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//            nextController.canShowNavigation = YES;
//            
//            UIViewController* topViewController=[Utility topViewController];
//            if (topViewController.navigationController) {
//                [topViewController.navigationController pushViewController:nextController animated:YES];
//            }else{
//                [topViewController dismissViewControllerAnimated:YES completion:^{
//                    [topViewController.navigationController pushViewController:nextController animated:YES];
//                }];
//            }
//        }
    }

}

-(void)logOutBecauseInvalidToken{
//        if ([[UserData shareInstance] SignOut]) {
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//            LoginViewcontroller *nextController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:nextController];
//            [navi.navigationBar setHidden:YES];
//            [self presentViewController:navi animated:YES completion:nil];
//        }else{
//            [self showAlertView:LZWarning message:LZError];
//        }
    
}

-(void)showTop{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    SplashScreen *nextController = [storyboard instantiateViewControllerWithIdentifier:@"SplashScreen"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:nextController];
    //[navi.navigationBar setHidden:YES];
    [self presentViewController:navi animated:YES completion:nil];
}

-(BOOL)signOut{
    if ([[UserData shareInstance]getToken]) {
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:[[UserData shareInstance]getToken] forKey:KeyAPI_TOKEN];

        [[NetworkCommunicator shareInstance] POST:API_LOGOUT parameters:params onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
            if(isSuccess) {
                [UserData shareInstance].userDataDictionary = nil;
                [[UserData shareInstance] clearUserData];
                [UserData shareInstance].isLogin = NO;
                //clear avatar img
                [[UserData shareInstance] setUserAvatarImg:nil];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                LoginScreen *nextController = [storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:nextController];
                [navi.navigationBar setHidden:YES];
                [self presentViewController:navi animated:YES completion:nil];
                
            }else{
                [self showAlertView:@"エラー" message:@"ログアウトすることはできません"];
            }
        }];
        return YES;
    }

    return NO;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
