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
#import "TenpossCommunicator.h"
#import "UIUtils.h"

@interface SplashScreen ()<TenpossCommunicatorDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;

@property(strong, nonatomic) NSString *errorMessage;

@end

@implementation SplashScreen

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!_errorMessage) {
        [_errorMessageLabel setHidden:NO];
    }
    
    [self.tryAgainButton setHidden:YES];
    
    [self.loadingIndicator startAnimating];
    
    [self loadAppConfig];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.loadingIndicator stopAnimating];
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
    if (!error){
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
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *appSettings =[appConfig getAvailableAppSettings];
    
    if ( appSettings != nil && [appConfig getAvailableSideMenu]) {
        
        MainNavigationController *mainNavigation = [[MainNavigationController alloc]initWithTemplateId:appSettings.template_id];
        SideMenuTableViewController *sideMenu = [[UIUtils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([SideMenuTableViewController class])]; //[[SideMenuTableViewController alloc] init];
        sideMenu.shouldSelectIndex = -1;
        MFSideMenuContainerViewController *viewController = [MFSideMenuContainerViewController
                                                             containerWithCenterViewController:mainNavigation
                                                             leftMenuViewController:sideMenu
                                                             rightMenuViewController:nil];
        
        sideMenu.delegate = (id<SideMenuDelegate>)mainNavigation.rootViewController;
        [sideMenu setData:[appConfig getAvailableSideMenu]];
        __weak SplashScreen *weakSelf = self;
        [viewController setModalPresentationStyle:UIModalPresentationCustom];
        viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:viewController animated:YES completion:^{
            for(UIView *subView in weakSelf.view.subviews){
                [subView setHidden:YES];
            }
        }];
    }
}

#pragma mark - TenpossCommunicatorDelegate
- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    
}
- (void)begin:(TenpossCommunicator*)request data:(Bundle*) responseParams{}
-( void)cancelAllRequest{}


@end
