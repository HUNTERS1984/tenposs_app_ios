//
//  LoginScreen_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/2/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "LoginScreen_t2.h"

@interface LoginScreen_t2 ()

@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet UIPageControl *navPageControl;

@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *loginEmailButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation LoginScreen_t2

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.view layoutIfNeeded];
    
    _twitterButton.layer.cornerRadius = 5;
    _facebookButton.layer.cornerRadius = 5;
    _loginEmailButton.layer.cornerRadius = 5;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeNavigationBarTitle:(NSString *)title showPageControl:(BOOL)show currentPage:(NSInteger)pageIndex{
    [self.navTitle setText:title];
    [self.navPageControl setHidden:show];
    if (show) {
        [self.navPageControl setCurrentPage:pageIndex];
    }
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
