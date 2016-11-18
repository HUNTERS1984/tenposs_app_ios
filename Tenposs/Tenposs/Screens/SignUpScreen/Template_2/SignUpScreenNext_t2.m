//
//  SignUpScreenNext_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/3/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SignUpScreenNext_t2.h"
#import "AppConfiguration.h"
#import "HexColors.h"
#import "UIFont+Themify.h"

@interface SignUpScreenNext_t2 ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation SignUpScreenNext_t2

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.view layoutIfNeeded];
    
    _contentView.layer.cornerRadius = 5;
    _contentView.clipsToBounds = YES;
    
    _signUpButton.layer.cornerRadius = 5;
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
}

- (void)didPressBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signUpTouch:(id)sender {
    
}

@end
