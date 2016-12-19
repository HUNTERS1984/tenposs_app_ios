//
//  GrandViewController.m
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/12/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import "GrandViewController.h"
#import "SideMenuViewController.h"
#import "UIFont+Themify.h"
#import "HexColors.h"
#import "UIViewController+LoadingView.h"
#import "MainNavigationController.h"
#import "CouponRequestListScreen.h"
#import "Utils.h"
#import "ScannerScreen.h"

@interface GrandViewController ()<SideMenuDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UILabel *navigationTitle;

@property (strong, nonatomic) NSMutableDictionary *cachedChildController;
@property (strong, nonatomic) UIViewController *currentChildController;

@end

@implementation GrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_cachedChildController == nil) {
        _cachedChildController = [NSMutableDictionary new];
    }
    
    [self setNavigationBarStyle:NavigationBarStyleDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(_currentChildController == nil){
        [self showLoadingViewWithMessage:@""];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CouponRequestListScreen *sc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CouponRequestListScreen class])];
    
    UIBarButtonItem* rightButton = self.navigationItem.rightBarButtonItem;
    [rightButton setImage:[[UIImage imageNamed:@"icon_scanner"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self presentChildViewController:sc];
    
    [self removeAllInfoView];
}

- (IBAction)openScanner:(id)sender {
    ScannerScreen *scannerScreen = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([ScannerScreen class])];
    [self.navigationController pushViewController:scannerScreen animated:YES];
}

- (IBAction)toggleMenu:(id)sender{
    if ([self.navigationController isKindOfClass:[MainNavigationController class]]) {
        [((MainNavigationController *)self.navigationController) toogleMenu];
    }
}

#pragma mark - Public methods

- (void)setNavigationBarStyle:(NavigationBarStyle)style{
    
    switch (style) {
        case NavigationBarStyleDefault:{
            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:nil];
            [_menuButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIFont themifyFontOfSize:20/*[UIUtils getTextSizeWithType:settings.font_size]*/], NSFontAttributeName,
                                                 [UIColor colorWithHexString:@"15C8C8"], NSForegroundColorAttributeName,
                                                 nil]
                                       forState:UIControlStateNormal];
            [_menuButton setTitle:[NSString stringWithFormat: [UIFont stringForThemifyIdentifier:@"ti-menu"]]];
//            self.navigationController.navigationBar.backgroundColor= [UIColor colorWithHexString:@"15C8C8"];
            
            _navigationTitle.numberOfLines = 1;
            _navigationTitle.minimumFontSize = 10;
            _navigationTitle.adjustsFontSizeToFitWidth = YES;
            [_navigationTitle setTextColor:[UIColor colorWithHexString:@"212121"]];
        }
            break;
        case NavigationBarStyleLight:{
            
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            self.navigationController.navigationBar.translucent = YES;
            
            [_menuButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIFont themifyFontOfSize:20/*[UIUtils getTextSizeWithType:settings.font_size]*/], NSFontAttributeName,
                                                 [UIColor colorWithHexString:@"FFFFFF"], NSForegroundColorAttributeName,
                                                 nil]
                                       forState:UIControlStateNormal];
            [_menuButton setTitle:[NSString stringWithFormat: [UIFont stringForThemifyIdentifier:@"ti-menu"]]];
            self.navigationController.navigationBar.backgroundColor= [UIColor clearColor];
            
            _navigationTitle.numberOfLines = 1;
            _navigationTitle.minimumFontSize = 10;
            _navigationTitle.adjustsFontSizeToFitWidth = YES;
            [_navigationTitle setTextColor:[UIColor colorWithHexString:@"FFFFFF"]];
        }
            break;
        case NavigationBarStyleDark:{
            
        }
            break;
        default:
            break;
    }
}

- (void)setNavigationBarTitle:(NSString *)title{
    if (_navigationTitle != nil) {
        [_navigationTitle setText:title.capitalizedString];
    }
}

- (void)presentChildViewController:(UIViewController *)child{
    if (self.currentChildController) {
        [self.currentChildController.view removeFromSuperview];
        [self.currentChildController removeFromParentViewController];
    }
    self.currentChildController = child;
    [self addChildViewController:child];
    [self.view addSubview:child.view];
    [child didMoveToParentViewController:self];
}


#pragma mark - SideMenuDelegate

- (void)didSelectSideMenuItem:(NSObject *)item{
    
}

@end
