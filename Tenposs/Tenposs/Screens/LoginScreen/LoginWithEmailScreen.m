//
//  LoginWithEmailScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/30/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "LoginWithEmailScreen.h"

@interface LoginWithEmailScreen ()

@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation LoginWithEmailScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    return NO;
}

- (void)sendLoginRequest{
    
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
