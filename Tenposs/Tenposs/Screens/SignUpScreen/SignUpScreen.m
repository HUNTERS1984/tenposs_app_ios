//
//  SignUpScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/1/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SignUpScreen.h"
#import "CXAHyperlinkLabel.h"
#import "NetworkCommunicator.h"
#import "UserData.h"
#import "AppDelegate.h"

@interface SignUpScreen ()

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *re_password;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;
@property (weak, nonatomic) IBOutlet CXAHyperlinkLabel *loginLabel;

@end

@implementation SignUpScreen

- (void)viewWillAppear:(BOOL)animated {
    NSRange range = [_loginLabel.text rangeOfString:@"こちらへ"];
    NSURL *url = [NSURL URLWithString:@"http://local.com"];
    _loginLabel.userInteractionEnabled = YES;
    [_loginLabel setURL:url forRange:range];
    [_loginLabel highlightLinkAtRange:range];
   // __weak __typeof(self)weakSelf = self;
    _loginLabel.URLClickHandler = ^(CXAHyperlinkLabel *label, NSURL *URL, NSRange textRange, NSArray *textRects){
        [self dismissViewControllerAnimated:YES completion:nil];
    };

}

- (IBAction)buttonClick:(id)sender{
    if (sender == _closeButton) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (sender == _registerButton){
        if ([self validateEnteredInfo]) {
            [self doRegister];
        }
    }
}

- (BOOL)validateEnteredInfo{
    
    if ([_name.text isEqualToString:@""] || [_email.text isEqualToString:@""] || ![self validateEmailWithString:_email.text]){
        [self showAlertView:@"警告" message:@"メールと名前を入力してください"];
        return NO;
    }
    
    if ([_password.text isEqualToString:@""]){
        [self showAlertView:@"警告" message:@"パスワード入力してください"];
        return NO;
    }
    
    if (![_re_password.text isEqualToString:_password.text]){
        [self showAlertView:@"警告" message:@"確認パスワードが正しくありません"];
        return NO;
    }
    
    return YES;
}

- (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)doRegister{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:_email.text forKey:KeyAPI_EMAIL];
    [params setObject:_password.text forKey:KeyAPI_PASSWORD];
    [params setObject:_name.text forKey:KeyAPI_USERNAME];
    
    [[NetworkCommunicator shareInstance] POST:API_SIGNUP parameters:params onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
        if(isSuccess) {
            [UserData shareInstance].userDataDictionary = [dictionary mutableCopy];
            [[UserData shareInstance] saveUserData];
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [delegate registerPushNotification];
            [self showTop];
        }else{
            [self showAlertView:@"エラー" message:@"新規会員登録できません"];
        }
    }];
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

@end
