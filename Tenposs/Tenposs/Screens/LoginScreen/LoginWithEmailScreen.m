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

@interface LoginWithEmailScreen ()<TenpossCommunicatorDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@end

@implementation LoginWithEmailScreen

- (void)viewWillAppear:(BOOL)animated {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[self.signupButton attributedTitleForState:UIControlStateNormal]];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:31/255.0 green:192/255.0 blue:186/255.0 alpha:1.0] range:NSMakeRange(0, attributedString.length)];
    
    [self.signupButton setAttributedTitle:attributedString forState:UIControlStateNormal];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(tapViewAction:)];
    [self.view addGestureRecognizer:tapGesture];
    
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
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:_emailText.text forKey:KeyAPI_EMAIL];
    [params setObject:_passwordText.text forKey:KeyAPI_PASSWORD];
    //[params setObject:@"luong.hong.quan@mqsolutions.vn" forKey:KeyAPI_EMAIL];
    //[params setObject:@"123456" forKey:KeyAPI_PASSWORD];

    [[NetworkCommunicator shareInstance] POST:API_LOGIN parameters:params onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
        if(isSuccess) {
            [UserData shareInstance].userDataDictionary = [dictionary mutableCopy];
            [[UserData shareInstance] saveUserData];
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [delegate registerPushNotification];
            [self showTop];
        }else{
            [self showAlertView:@"エラー" message:@"ログインできません"];
        }
    }];
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
