//
//  SignUpScreen_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/3/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SignUpScreen_t2.h"
#import "AppConfiguration.h"
#import "HexColors.h"
#import "UIFont+Themify.h"
#import "NetworkCommunicator.h"
#import "UserData.h"
#import "AppDelegate.h"
#import "SplashScreen.h"
#import "SignUpScreenNext_t2.h"

@interface SignUpScreen_t2 ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *rePassword;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) NSMutableDictionary *signUpData;

@end

@implementation SignUpScreen_t2

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.view layoutIfNeeded];
    
    _contentView.layer.cornerRadius = 5;
    _contentView.clipsToBounds = YES;
    
    _nextButton.layer.cornerRadius = 5;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *settings = [appConfig getAvailableAppSettings];
    
    if ([[self.navigationController viewControllers] count] > 1) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(didPressBackButton)];
        self.navigationItem.leftBarButtonItem = backButton;
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.navigationItem setBackBarButtonItem:nil];
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                       [UIFont themifyFontOfSize:20/*[UIUtils getTextSizeWithType:settings.font_size]*/], NSFontAttributeName,
                                                                       [UIColor colorWithHexString:@"ffffff"], NSForegroundColorAttributeName,
                                                                       nil]
                                                             forState:UIControlStateNormal];
        [self.navigationItem.leftBarButtonItem setTitle:[NSString stringWithFormat: @"%@", [UIFont stringForThemifyIdentifier:@"ti-angle-left"]]];
    }
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didPressBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextTouched:(id)sender {
    
}

- (BOOL)validateEnteredInfo{
    
    if ([_userName.text isEqualToString:@""] || [_email.text isEqualToString:@""] || ![self validateEmailWithString:_email.text]){
        [self showAlertView:@"警告" message:@"メールと名前を入力してください"];
        return NO;
    }
    
    if ([_password.text isEqualToString:@""]){
        [self showAlertView:@"警告" message:@"パスワード入力してください"];
        return NO;
    }
    
    if (![_rePassword.text isEqualToString:_password.text]){
        [self showAlertView:@"警告" message:@"確認パスワードが正しくありません"];
        return NO;
    }
    _signUpData = [NSMutableDictionary new];
    [_signUpData setObject:_userName.text forKey:@"name"];
    [_signUpData setObject:_email.text forKey:@"email"];
    [_signUpData setObject:_password.text forKey:@"password"];
    
    return YES;
}

- (BOOL)validateEmailWithString:(NSString*)checkString{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void)showAlertView:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"閉じる" otherButtonTitles:nil];
    [alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"signup_to_next2"]) {
        SignUpScreenNext_t2 *nextScreen = (SignUpScreenNext_t2 *) segue.destinationViewController;
        if (nextScreen) {
            nextScreen.signUpData = [_signUpData mutableCopy];
        }
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"signup_to_next2"]) {
        if ([self validateEnteredInfo]) {
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}

@end
