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
#import "AppConfiguration.h"
#import "HexColors.h"
#import "UIFont+Themify.h"
#import "UIUtils.h"
#import "SignUpScreenNext.h"
#import "Const.h"

@interface SignUpScreen ()

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *re_password;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;
@property (weak, nonatomic) IBOutlet CXAHyperlinkLabel *loginLabel;
@property (weak, nonatomic) IBOutlet UINavigationBar *nav;

@property (strong, nonatomic) NSMutableDictionary *signUpData;

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
//        if ([self validateEnteredInfo]) {
//            [self doRegister];
//        }
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
    
    if (!_signUpData) {
        _signUpData = [[NSMutableDictionary alloc] init];
    }
    [_signUpData setObject:_name.text forKey:@"name"];
    [_signUpData setObject:_email.text forKey:@"email"];
    [_signUpData setObject:_password.text forKey:@"password"];
    
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

- (NSString *)title{
    return @"新規会員登録 (1/2)";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(tapViewAction:)];
    [self.view addGestureRecognizer:tapGesture];
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *settings = [appConfig getAvailableAppSettings];
    
//    [_closeButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                         [UIFont themifyFontOfSize:[UIUtils getTextSizeWithType:settings.font_size]], NSFontAttributeName,
//                                         [UIColor colorWithHexString:settings.title_color], NSForegroundColorAttributeName,
//                                         nil]
//                               forState:UIControlStateNormal];
//    [_closeButton setTitle:[NSString stringWithFormat: [UIFont stringForThemifyIdentifier:@"ti-close"]]];
//    _nav.backgroundColor= [UIColor colorWithHexString:settings.header_color];
//    [_nav setTitleTextAttributes:
//     @{NSForegroundColorAttributeName:[UIColor colorWithHexString:settings.title_color]}];
    
    if (self.navigationController) {
        UINavigationBar *navBar = self.navigationController.navigationBar;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(didPressCloseButton)];
        self.navigationItem.leftBarButtonItem = backButton;
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.navigationItem setBackBarButtonItem:nil];
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                       [UIFont themifyFontOfSize:20/*[UIUtils getTextSizeWithType:settings.font_size]*/], NSFontAttributeName,
                                                                       [UIColor colorWithHexString:settings.title_color], NSForegroundColorAttributeName,
                                                                       nil]
                                                             forState:UIControlStateNormal];
        [self.navigationItem.leftBarButtonItem setTitle:[NSString stringWithFormat: @"%@", [UIFont stringForThemifyIdentifier:@"ti-close"]]];
    }

}

- (void)didPressCloseButton{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"signup_to_next"]) {
        SignUpScreenNext *nextScreen = (SignUpScreenNext *) segue.destinationViewController;
        if (nextScreen) {
            nextScreen.signUpData = [_signUpData mutableCopy];
        }
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"signup_to_next"]) {
        if ([self validateEnteredInfo]) {
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}

-(void)tapViewAction:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
