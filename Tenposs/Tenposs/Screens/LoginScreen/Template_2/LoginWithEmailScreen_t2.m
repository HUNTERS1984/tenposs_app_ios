//
//  LoginWithEmailScreen_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/2/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "LoginWithEmailScreen_t2.h"
#import "LoginScreen_t2.h"
#import "UIFont+Themify.h"
#import "HexColors.h"
#import "AppConfiguration.h"
#import "NetworkCommunicator.h"
#import "UserData.h"
#import "AppDelegate.h"

@interface LoginWithEmailScreen_t2 ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation LoginWithEmailScreen_t2

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.view layoutIfNeeded];
    
    _contentView.layer.cornerRadius = 5;
    _contentView.clipsToBounds = YES;
    
    _loginButton.layer.cornerRadius = 5;
    _loginButton.clipsToBounds = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    //TODO: Clean
    [_email setText:@"luong.hong.quan@mqsolutions.vn"];
    [_password setText:@"123456"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *settings = [appConfig getAvailableAppSettings];
    
    if ([[self.navigationController viewControllers] count] > 1) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(didPressCloseButton)];
        self.navigationItem.leftBarButtonItem = backButton;
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.navigationItem setBackBarButtonItem:nil];
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                       [UIFont themifyFontOfSize:20/*[UIUtils getTextSizeWithType:settings.font_size]*/], NSFontAttributeName,
                                                                       [UIColor colorWithHexString:@"ffffff"], NSForegroundColorAttributeName,
                                                                       nil]
                                                             forState:UIControlStateNormal];
        [self.navigationItem.leftBarButtonItem setTitle:[NSString stringWithFormat: @"%@", [UIFont stringForThemifyIdentifier:@"ti-close"]]];
    }
}

- (void)didPressCloseButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doEmailLogin:(id)sender{
    if([self validateEmailAndPassword]){
        [self sendLoginRequest];
    }
}

- (BOOL)validateEmailAndPassword{
    if ([_email.text isEqualToString:@""] || [_password.text isEqualToString:@""]){
        [self showAlertView:@"警告" message:@"メールとアドレスを入力してください"];
        return NO;
    }
    return YES;
}

- (void)sendLoginRequest{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:_email.text forKey:KeyAPI_EMAIL];
    [params setObject:_password.text forKey:KeyAPI_PASSWORD];
    //    [params setObject:@"luong.hong.quan@mqsolutions.vn" forKey:KeyAPI_EMAIL];
    //    [params setObject:@"123456" forKey:KeyAPI_PASSWORD];
    
    [[NetworkCommunicator shareInstance] POST:API_LOGIN parameters:params onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
        if(isSuccess) {
            [UserData shareInstance].userDataDictionary = [dictionary mutableCopy];
            [[UserData shareInstance] saveUserData];
            
            //            if ([[UserData shareInstance] getUserEmail] == nil) {
            //                [[UserData shareInstance] setUserEmail:_email.text];
            //            }
            
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [delegate registerPushNotification];
            [self showTop];
        }else{
            [self showAlertView:@"エラー" message:@"ログインできません"];
        }
    }];
}

@end
