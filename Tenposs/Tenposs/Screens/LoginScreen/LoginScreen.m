//
//  LoginScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/29/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "LoginScreen.h"
#import "HexColors.h"

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
    self.skipButton.layer.cornerRadius = 5;
    
    self.loginWithEmailButton.layer.cornerRadius = 5;
    self.loginWithEmailButton.clipsToBounds = true;
    
    self.loginTwitterButton.layer.cornerRadius = 5;
    self.loginTwitterButton.clipsToBounds = true;
    
    self.loginFacebookButton.layer.cornerRadius = 5;
    self.loginFacebookButton.clipsToBounds = true;
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

- (void) doEmailLogin{
    
    [self performSegueWithIdentifier:@"login_email" sender:nil];
    
}

- (void) doFacebookLogin{
    
}

- (void) doTwitterLogin{
    
}

@end
