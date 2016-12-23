//
//  LoginScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/29/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "LoginScreen.h"
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
#import "SignUpScreenNext.h"
#import "SVProgressHUD.h"

@interface LoginScreen ()
@property (weak, nonatomic) IBOutlet UILabel *appTitle;

@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *loginWithEmailButton;
@property (weak, nonatomic) IBOutlet UIButton *loginTwitterButton;
@property (weak, nonatomic) IBOutlet UIButton *loginFacebookButton;

@end

@implementation LoginScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self customizeButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (void)customizeButton{
    self.skipButton.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:0.5f];
}

- (IBAction)buttionClicked:(id)sender{
    
    //TODO: need implement others button
    if (sender == _skipButton) {
        [self performSegueWithIdentifier:@"login_skip" sender:nil];
    }else if(sender == _loginWithEmailButton){
        [self doEmailLogin];
    }else if (sender == _loginFacebookButton){
    
    }else if (sender == _loginTwitterButton){
    
    }
}

- (IBAction)buttionFacebookClicked:(id)sender{
    //[SVProgressHUD show];
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
                         [params setObject:[result objectForKey:@"name"] forKey:KeyAPI_USERNAME_NAME];
                         [params setObject:@"ios" forKey:KeyAPI_PLATFORM];
                         
                         NSMutableDictionary *avatarInfo = [[NSMutableDictionary alloc] init];
                         [avatarInfo setObject:@(200) forKey:@"height"];
                         [avatarInfo setObject:@(200) forKey:@"width"];
                         [avatarInfo setObject:@"large" forKey:@"type"];
                         [avatarInfo setObject:@(0) forKey:@"redirect"];
                         NSString *userId = [result objectForKey:@"id"];
                         NSString *graph = [NSString stringWithFormat:@"/%@/picture",userId];
                         FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                                       initWithGraphPath:graph
                                                       parameters:avatarInfo
                                                       HTTPMethod:@"GET"];
                         [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                               id result,
                                                               NSError *error) {
                             NSLog(@"Facebook avatar result : %@", result);
                             NSString *avatar_url = nil;
                             if(result){
                                 NSDictionary *data = [result objectForKey:@"data"];
                                 if (data) {
                                     avatar_url= [data objectForKey:@"url"];
                                 }
                             }
                             
                             if (avatar_url) {
                                 [params setObject:avatar_url forKey:KeyAPI_AVATAR_URL];
                             }
                             
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
                                     BOOL isFirstLogin = [[userData objectForKey:@"first_login"] boolValue];
                                     //[SVProgressHUD dismiss];
                                     if (isFirstLogin) {
                                         //TODO: show additional info
                                         UIViewController *nextController = [[UIUtils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([SignUpScreenNext class])];
                                         UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:nextController];
                                         //[navi.navigationBar setHidden:YES];
                                         [self presentViewController:navi animated:YES completion:nil];
                                         
                                         UIViewController *addInfoScreen = [[UIUtils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([SignUpScreenNext class])];
                                         [self presentViewController:addInfoScreen animated:YES completion:nil];
                                     }else{
                                         AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                                         [delegate registerPushNotification];
                                         [self showTop];
                                     }
                                 }else{
                                     //[SVProgressHUD dismiss];
                                     [self showAlertView:@"エラー" message:@"新規会員登録できません"];
                                 }
                             }];
                         }];
                         
                     }
                 }];
            }
        }
    }];
}

- (IBAction)buttionTwitterClicked:(id)sender{
    //[SVProgressHUD show];
    [[Twitter sharedInstance] logInWithViewController:self methods:TWTRLoginMethodAll completion:^(TWTRSession *session, NSError *error) {
        if (session) {
            __weak TWTRSession *wSession = session;
            NSString *tUserId = [session userID];
            TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:tUserId];
            [client loadUserWithID:tUserId completion:^(TWTRUser * _Nullable user, NSError * _Nullable error) {
                NSMutableDictionary *params = [NSMutableDictionary new];
                [params setObject:APP_ID forKey:KeyAPI_APP_ID];
                [params setObject:@"2" forKey:KeyAPI_SOCIAL_TYPE];
                [params setObject:[wSession userID] forKey:KeyAPI_SOCIAL_ID];
                [params setObject:[wSession authToken] forKey:KeyAPI_SOCIAL_TOKEN];
                [params setObject:[wSession authTokenSecret] forKey:KeyAPI_SOCIAL_SECRET];
                [params setObject:[wSession userName] forKey:KeyAPI_USERNAME_NAME];
                [params setObject:[user profileImageURL] forKey:KeyAPI_AVATAR_URL];
                [params setObject:@"ios" forKey:KeyAPI_PLATFORM];
                [[AuthenticationManager sharedInstance] AuthSignUpWithSocialAccount:params andCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
                    //[SVProgressHUD dismiss];
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
                        BOOL isFirstLogin = [[userData objectForKey:@"first_login"] boolValue];
                        if (isFirstLogin) {
                            //TODO: show additional info
                            UIViewController *nextController = [[UIUtils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([SignUpScreenNext class])];
                            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:nextController];
                            //[navi.navigationBar setHidden:YES];
                            [self presentViewController:navi animated:YES completion:nil];
                            
                            UIViewController *addInfoScreen = [[UIUtils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([SignUpScreenNext class])];
                            [self presentViewController:addInfoScreen animated:YES completion:nil];

                        }else{
                            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                            [delegate registerPushNotification];
                            [self showTop];
                        }
                        
                    }else{
                        //[SVProgressHUD dismiss];
                        [self showAlertView:@"エラー" message:@"新規会員登録できません"];
                    }
                }];
            }];
            NSLog(@"signed in as %@", [session userName]);
            
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}

- (void) doEmailLogin{
    
    [self performSegueWithIdentifier:@"login_email" sender:nil];
    
}

- (void) doFacebookLogin{
    
}

- (void) doTwitterLogin{
    
}

@end
