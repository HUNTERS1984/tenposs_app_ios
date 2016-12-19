//
//  BaseViewController.m
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/13/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import "BaseViewController.h"
#import "HexColors.h"
#import "UIFont+Themify.h"
#import "UIImage+Font.h"
#import "LoginScreen.h"
#import "GrandViewController.h"
#import "MainNavigationController.h"
#import "SideMenuViewController.h"
#import "Utils.h"
#import "MFSideMenu.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[self.navigationController viewControllers] count] > 1) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(didPressBackButton)];
        self.navigationItem.leftBarButtonItem = backButton;
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.navigationItem setBackBarButtonItem:nil];
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                       [UIFont themifyFontOfSize:20/*[UIUtils getTextSizeWithType:settings.font_size]*/], NSFontAttributeName,
                                                                       [UIColor colorWithHexString:@"15C8C8"], NSForegroundColorAttributeName,
                                                                       nil]
                                                             forState:UIControlStateNormal];
        [self.navigationItem.leftBarButtonItem setTitle:[NSString stringWithFormat: [UIFont stringForThemifyIdentifier:@"ti-angle-left"]]];
    }

}

-(void)showLogin{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    LoginScreen *nextController = [storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:nextController];
    [navi.navigationBar setHidden:YES];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)showHomeScreen{
    GrandViewController *rootViewController = [[Utils mainStoryboard]instantiateViewControllerWithIdentifier:NSStringFromClass([GrandViewController class])];
    MainNavigationController *mainNavigation = [[MainNavigationController alloc]initWithRootViewController:rootViewController];
    SideMenuViewController *sideMenu = [[Utils mainStoryboard]instantiateViewControllerWithIdentifier:NSStringFromClass([SideMenuViewController class])];//[[SideMenuViewController alloc] init];
    MFSideMenuContainerViewController *viewController = [MFSideMenuContainerViewController
                                                         containerWithCenterViewController:mainNavigation
                                                         leftMenuViewController:sideMenu
                                                         rightMenuViewController:nil];
    
    sideMenu.delegate = (id<SideMenuDelegate>)mainNavigation.rootViewController;
    
    [viewController setModalPresentationStyle:UIModalPresentationCustom];
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
