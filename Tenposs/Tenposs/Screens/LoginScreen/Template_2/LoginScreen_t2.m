//
//  LoginScreen_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/2/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "LoginScreen_t2.h"
#import "HexColors.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "NetworkCommunicator.h"
#import "UserData.h"
#import "AppDelegate.h"
#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>
#import "AuthenticationManager.h"
#import "Const.h"
#import "Utils.h"
#import "SVProgressHUD.h"
#import "UIUtils.h"
#import "SignUpScreenNext_t2.h"

@interface LoginScreen_t2 ()

@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet UIPageControl *navPageControl;

@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *loginEmailButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;

@end

@implementation LoginScreen_t2

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.view layoutIfNeeded];
    
    _twitterButton.layer.cornerRadius = 5;
    _facebookButton.layer.cornerRadius = 5;
    _loginEmailButton.layer.cornerRadius = 5;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeNavigationBarTitle:(NSString *)title showPageControl:(BOOL)show currentPage:(NSInteger)pageIndex{
    [self.navTitle setText:title];
    [self.navPageControl setHidden:show];
    if (show) {
        [self.navPageControl setCurrentPage:pageIndex];
    }
}

- (IBAction)buttionFacebookClicked:(id)sender{
    [SVProgressHUD show];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email", @"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
            NSLog(@"error %@",error);
        } else if (result.isCancelled) {
            // Handle cancellations
            NSLog(@"Cancelled");
        } else {
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                NSString *token = result.token.tokenString;
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         NSLog(@"fetched user:%@", result);
                         NSMutableDictionary *params = [NSMutableDictionary new];
                         [params setObject:APP_ID forKey:KeyAPI_APP_ID];
                         [params setObject:@"1" forKey:KeyAPI_SOCIAL_TYPE];
                         [params setObject:[result objectForKey:@"id"] forKey:KeyAPI_SOCIAL_ID];
                         [params setObject:token forKey:KeyAPI_SOCIAL_TOKEN];
                         [params setObject:[result objectForKey:@"name"] forKey:KeyAPI_USERNAME];
                         [params setObject:@"ios" forKey:KeyAPI_PLATFORM];
                         NSLog(@"SOCIAL LOGIN = %@", params);
                         [[AuthenticationManager sharedInstance] AuthSignUpWithSocialAccount:params andCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
                             if(isSuccess) {
                                 NSMutableDictionary *userData;
                                 if ([resultData isKindOfClass:[CommonResponse class]]) {
                                     userData = [((CommonResponse *)resultData).data mutableCopy];
                                 }else{
                                     userData = [resultData mutableCopy];
                                 }
                                 
                                 NSMutableDictionary *tokenKit = [[NSMutableDictionary alloc] init];
                                 if ([userData objectForKey:@"token"]) {
                                     [tokenKit setObject:[userData objectForKey:@"token"] forKey:@"token"];
                                     [userData removeObjectForKey:@"token"];
                                 }
                                 if ([userData objectForKey:@"refresh_token"]) {
                                     [tokenKit setObject:[userData objectForKey:@"refresh_token"] forKey:@"refresh_token"];
                                     [userData removeObjectForKey:@"refresh_token"];
                                 }
                                 if ([userData objectForKey:@"access_refresh_token_href"]) {
                                     [tokenKit setObject:[userData objectForKey:@"access_refresh_token_href"] forKey:@"access_refresh_token_href"];
                                     [userData removeObjectForKey:@"access_refresh_token_href"];
                                 }
                                 
                                 [UserData shareInstance].userDataDictionary = [userData mutableCopy];
                                 [[UserData shareInstance] saveUserData];
                                 [[UserData shareInstance] saveTokenKit:[tokenKit copy]];
                                 BOOL isFirstLogin = [userData objectForKey:@"first_login"];
                                 [SVProgressHUD dismiss];
                                 if (isFirstLogin) {
                                     //TODO: show additional info
                                     UIStoryboard *mainStoryboard = nil;
                                     mainStoryboard = [UIStoryboard storyboardWithName:@"Main_t2" bundle: nil];
                                     UIViewController *addInfoScreen = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([SignUpScreenNext_t2 class])];
                                     [self presentViewController:addInfoScreen animated:YES completion:nil];
                                 }else{
                                     AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                                     [delegate registerPushNotification];
                                     [self showTop];
                                 }
                             }else{
                                 
                             }
                         }];
                     }
                 }];
            }
        }
    }];
}

- (IBAction)buttionTwitterClicked:(id)sender{
    [SVProgressHUD show];
    [[Twitter sharedInstance] logInWithViewController:self methods:TWTRLoginMethodAll completion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setObject:APP_ID forKey:KeyAPI_APP_ID];
            [params setObject:@"2" forKey:KeyAPI_SOCIAL_TYPE];
            [params setObject:[session userID] forKey:KeyAPI_SOCIAL_ID];
            [params setObject:[session authToken] forKey:KeyAPI_SOCIAL_TOKEN];
            [params setObject:[session authTokenSecret] forKey:KeyAPI_SOCIAL_SECRET];
            [params setObject:[session userName] forKey:KeyAPI_USERNAME];
            [params setObject:@"ios" forKey:KeyAPI_PLATFORM];
            [[AuthenticationManager sharedInstance] AuthSignUpWithSocialAccount:params andCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
                [SVProgressHUD dismiss];
                if(isSuccess) {
                    NSMutableDictionary *userData;
                    if ([resultData isKindOfClass:[CommonResponse class]]) {
                        userData = [((CommonResponse *)resultData).data mutableCopy];
                    }else{
                        userData = [resultData mutableCopy];
                    }
                    
                    NSMutableDictionary *tokenKit = [[NSMutableDictionary alloc] init];
                    if ([userData objectForKey:@"token"]) {
                        [tokenKit setObject:[userData objectForKey:@"token"] forKey:@"token"];
                        [userData removeObjectForKey:@"token"];
                    }
                    if ([userData objectForKey:@"refresh_token"]) {
                        [tokenKit setObject:[userData objectForKey:@"refresh_token"] forKey:@"refresh_token"];
                        [userData removeObjectForKey:@"refresh_token"];
                    }
                    if ([userData objectForKey:@"access_refresh_token_href"]) {
                        [tokenKit setObject:[userData objectForKey:@"access_refresh_token_href"] forKey:@"access_refresh_token_href"];
                        [userData removeObjectForKey:@"access_refresh_token_href"];
                    }
                    
                    [UserData shareInstance].userDataDictionary = [userData mutableCopy];
                    [[UserData shareInstance] saveUserData];
                    [[UserData shareInstance] saveTokenKit:[tokenKit copy]];
                    BOOL isFirstLogin = [userData objectForKey:@"first_login"];
                    if (isFirstLogin) {
                        //TODO: show additional info
                        UIStoryboard *mainStoryboard = nil;
                        mainStoryboard = [UIStoryboard storyboardWithName:@"Main_t2" bundle: nil];
                        UIViewController *addInfoScreen = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([SignUpScreenNext_t2 class])];
                        [self presentViewController:addInfoScreen animated:YES completion:nil];
                    }else{
                        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                        [delegate registerPushNotification];
                        [self showTop];
                    }
                    
                }else{
                    
                }
            }];
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}

- (IBAction)buttonSKipClicked:(id)sender{
    [self showTop];
}

@end
