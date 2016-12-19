//
//  LoginScreen.m
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/12/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import "LoginScreen.h"
#import "NetworkCommunicator.h"
#import "UserData.h"
#import "AppDelegate.h"
#import "Const.h"
#import "SVProgressHUD.h"
#import "AuthenticationManager.h"

@interface LoginScreen ()<UITextFieldDelegate>{
    UITextField *activeField;
}

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;

@end

@implementation LoginScreen

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.view layoutIfNeeded];
    
    _topView.layer.cornerRadius = 20;
    _topView.clipsToBounds = YES;
    
    _infoView.layer.cornerRadius = 5;
    _infoView.clipsToBounds = YES;
    
    _loginButton.layer.cornerRadius = 5;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TODO: Clean
    [_username setText:@"quanlh218@gmail.com"];
    [_password setText:@"123456"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [_scrollContentView addGestureRecognizer:tap];
    
    [_username setReturnKeyType:UIReturnKeyNext];
    [_password setReturnKeyType:UIReturnKeyDone];
    
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Handle Keyboard display

- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeKeyboardNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification{
    _scrollView.scrollEnabled = YES;
    
    NSDictionary *info = [notification userInfo];
    
    NSValue *keyboardValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    
    CGSize keyboardSize = keyboardValue.CGRectValue.size;
    
    CGPoint buttonOrigin = _loginButton.frame.origin;
    CGFloat buttonHeight = _loginButton.frame.size.height;
    
    CGRect visibleRect = self.view.frame;
    
    visibleRect.size.height -= keyboardSize.height;
    
    if(activeField){
        if(!CGRectContainsPoint(visibleRect, _loginButton.frame.origin)){
            CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
            [self.scrollView setContentOffset:scrollPoint animated:YES];
        }
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification{
    
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    
    self.scrollView.scrollEnabled = NO;
}

- (void)hideKeyboard{
    if (activeField) {
        [activeField resignFirstResponder];
    }
}

#pragma mark - Private methods

-(void) doLogin{
    if ([self validateUsernameAndPassword]) {
        [SVProgressHUD showWithStatus:@"Logging in"];
        [self sendLoginRequest];
    }
}

- (void)sendLoginRequest{
    NSString *emailText = _username.text;
    NSString *passwordText = _password.text;
    [[AuthenticationManager sharedInstance] AuthLoginWithEmail:emailText password:passwordText role:ROLE_STAFF andCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
        [SVProgressHUD dismiss];
        NSDictionary *result;
        if ([resultData isKindOfClass:[CommonResponse class]]) {
            result = [((CommonResponse *)resultData).data copy];
        }else{
            result = resultData;
        }
        if(isSuccess) {
            if([[UserData shareInstance] saveTokenKit:result]){
//                [self getUserProfile];
                AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [delegate registerPushNotification];
                [self showHomeScreen];
            }else{
                [self showAlertView:@"エラー" message:@"ログインできません"];
            }
        }else{
            [self showAlertView:@"エラー" message:@"ログインできません"];
        }
    }];
}

- (void)getUserProfile{
    [SVProgressHUD showWithStatus:@"Fetching user profile"];
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
                [self showHomeScreen];
            }else{
                //TODO: handle server did not return user data
            }
        }else{
            [self showAlertView:@"エラー" message:@"ログインできません"];
        }
    }];
}

- (void)handleLoginResponseWithError:(NSError *)error{
    if (!error) {
        
    }else{
        
    }
}

- (BOOL)validateUsernameAndPassword{
    if ([_username.text isEqualToString:@""] || [_password.text isEqualToString:@""]){
        [self showAlertView:@"警告" message:@"メールとアドレスを入力してください"];
        return NO;
    }
    return YES;
}

-(void)showAlertView:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"閉じる"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _username) {
        [_username resignFirstResponder];
        [_password becomeFirstResponder];
    }else if (textField == _password){
        [textField resignFirstResponder];
        [self doLogin];
    }
    return YES;
}

- (IBAction)loginButtonTapped:(id)sender {
    //TODO: clear mockup
    
//    [self showHomeScreen];
//    return;
    
    [self doLogin];
}

@end
