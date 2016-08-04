//
//  SplashScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SplashScreen.h"
#import "MainNavigationController.h"
#import "TopScreen.h"
#import "SideMenuTableViewController.h"
#import "MFSideMenu.h"

@interface SplashScreen ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;

@end

@implementation SplashScreen

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.loadingIndicator startAnimating];
    
    [self loadAppConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadAppConfig{
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    
    [appConfig loadAppInfoWithCompletionHandler:^(NSError *error) {
        [self handleAppInfoWithError:error];
    }];
}

- (void)handleAppInfoWithError:(NSError *)error{
    if (!error) {
        [self buildApp];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self.loadingIndicator stopAnimating];
            [self.loadingIndicator setHidden:YES];
            
            [self.errorMessageLabel setText:error.domain];
            [self.errorMessageLabel setHidden:NO];
            
            [self.tryAgainButton setHidden:NO];
        }];
        [self.tryAgainButton addTarget:self action:@selector(loadAppConfig) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buildApp{
    
    for(UIView *subView in self.view.subviews){
        [subView setHidden:YES];
    }
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    
    if (appConfig.appSettings) {
        MainNavigationController *mainNavigation = [[MainNavigationController alloc]initWithTemplateId:appConfig.appSettings.template_id];
        SideMenuTableViewController *sideMenu = [[SideMenuTableViewController alloc] init];
        
        MFSideMenuContainerViewController *viewController = [MFSideMenuContainerViewController
                                                             containerWithCenterViewController:mainNavigation
                                                             leftMenuViewController:sideMenu
                                                             rightMenuViewController:nil];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

@end
