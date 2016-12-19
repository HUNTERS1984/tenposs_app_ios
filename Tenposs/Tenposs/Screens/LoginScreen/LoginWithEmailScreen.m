//
//  LoginWithEmailScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/30/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "LoginWithEmailScreen.h"
#import "Const.h"
#import "Utils.h"
#import "UserData.h"
#import "NetworkCommunicator.h"
#import "AppDelegate.h"
#import "AppConfiguration.h"
#import "HexColors.h"
#import "UIFont+Themify.h"
#import "AuthenticationManager.h"
#import "SVProgressHUD.h"

@interface LoginWithEmailScreen ()<TenpossCommunicatorDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *nav;
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
@end

@implementation LoginWithEmailScreen

- (void)viewWillAppear:(BOOL)animated {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[self.signupButton attributedTitleForState:UIControlStateNormal]];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:31/255.0 green:192/255.0 blue:186/255.0 alpha:1.0] range:NSMakeRange(0, attributedString.length)];
    
    [self.signupButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *settings = [appConfig getAvailableAppSettings];
    
    [_doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont themifyFontOfSize:[UIUtils getTextSizeWithType:settings.font_size]], NSFontAttributeName,
                                         [UIColor colorWithHexString:settings.title_color], NSForegroundColorAttributeName,
                                         nil]
                               forState:UIControlStateNormal];
    [_doneButton setTitle:[NSString stringWithFormat: [UIFont stringForThemifyIdentifier:@"ti-close"]]];
    _nav.backgroundColor= [UIColor colorWithHexString:settings.header_color];
    [_nav setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithHexString:settings.title_color]}];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(tapViewAction:)];
    [self.view addGestureRecognizer:tapGesture];
    
    //TODO: Clean
    [_emailText setText:@"quanlh218@gmail.com"];
    [_passwordText setText:@"123456"];
    
}

-(void)tapViewAction:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender{
    if (sender == _doneButton) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (sender == _loginButton){
        if ([self validateEmailAndPassword]) {
            [self sendLoginRequest];
        }else {
            //TODO: show alert for missing fields
        }
    }
}

- (BOOL)validateEmailAndPassword{
    if ([_emailText.text isEqualToString:@""] || [_passwordText.text isEqualToString:@""]){
        [self showAlertView:@"警告" message:@"メールとアドレスを入力してください"];
        return NO;
    }
    return YES;
}

- (void)sendLoginRequest{
    [SVProgressHUD show];
    [[AuthenticationManager sharedInstance] AuthLoginWithEmail:_emailText.text password:_passwordText.text role:ROLE_USER andCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
        [SVProgressHUD dismiss];
        NSDictionary *result;
        if ([resultData isKindOfClass:[CommonResponse class]]) {
            result = [((CommonResponse *)resultData).data copy];
        }else{
            result = resultData;
        }
        if(isSuccess) {
            if([[UserData shareInstance] saveTokenKit:result]){
                [self getUserProfile];
            }else{
                [self showAlertView:@"エラー" message:@"ログインできません"];
            }
        }else{
            [self showAlertView:@"エラー" message:@"ログインできません"];
        }
    }];
}

- (void)getUserProfile{
    [SVProgressHUD show];
    [[AuthenticationManager sharedInstance] AuthGetUserProfileWithCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
        [SVProgressHUD dismiss];
        NSMutableDictionary *resultDict;
        if([resultData isKindOfClass:[CommonResponse class]]){
            CommonResponse *result = (CommonResponse *)resultData;
            resultDict = result.data;
        }else{
            resultDict = [resultData mutableCopy];
        }
        if(isSuccess){
            if ([resultDict objectForKey:@"user"]) {
                NSDictionary *userData = [resultDict objectForKey:@"user"];
                [UserData shareInstance].userDataDictionary = [userData mutableCopy];
                [[UserData shareInstance] saveUserData];
                AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [delegate registerPushNotification];
                [self showTop];
            }else{
                //TODO: handle server did not return user data
            }
        }else{
            [self showAlertView:@"エラー" message:@"ログインできません"];
        }
    }];
}

@end
