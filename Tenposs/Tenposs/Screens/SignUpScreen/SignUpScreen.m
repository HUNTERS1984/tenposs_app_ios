//
//  SignUpScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/1/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SignUpScreen.h"

@interface SignUpScreen ()

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *re_password;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;

@end

@implementation SignUpScreen

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
    
    return NO;
}

- (void)doRegister{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
