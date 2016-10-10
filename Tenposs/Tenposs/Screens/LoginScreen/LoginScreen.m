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

@interface LoginScreen ()

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
                         [params setObject:@"1" forKey:KeyAPI_SOCIAL_TYPE];
                         [params setObject:[result objectForKey:@"id"] forKey:KeyAPI_SOCIAL_ID];
                         [params setObject:token forKey:KeyAPI_SOCIAL_TOKEN];
                         [params setObject:[result objectForKey:@"name"] forKey:KeyAPI_USERNAME];
                         
                         [[NetworkCommunicator shareInstance] POST:API_SLOGIN parameters:params onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
                             if(isSuccess) {
                                 [UserData shareInstance].userDataDictionary = [dictionary mutableCopy];
                                 [[UserData shareInstance] saveUserData];
                                 AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                                 [delegate registerPushNotification];
                                 [self performSegueWithIdentifier:@"login_skip" sender:nil];
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
    
    [[Twitter sharedInstance] logInWithViewController:self methods:TWTRLoginMethodAll completion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setObject:@"2" forKey:KeyAPI_SOCIAL_TYPE];
            [params setObject:[session userID] forKey:KeyAPI_SOCIAL_ID];
            [params setObject:[session authToken] forKey:KeyAPI_SOCIAL_TOKEN];
            [params setObject:[session authTokenSecret] forKey:KeyAPI_SOCIAL_SECRET];
            [params setObject:[session userName] forKey:KeyAPI_USERNAME];
            
            [[NetworkCommunicator shareInstance] POST:API_SLOGIN parameters:params onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
                if(isSuccess) {
                    [UserData shareInstance].userDataDictionary = [dictionary mutableCopy];
                    [[UserData shareInstance] saveUserData];
                    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                    [delegate registerPushNotification];
                    [self performSegueWithIdentifier:@"login_skip" sender:nil];
                }else{
                    
                }
            }];
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
