//
//  GrandViewController.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/9/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "GrandViewController.h"

#import "AppConfiguration.h"
#import "HexColors.h"
#import "UIViewController+LoadingView.h"
#import "DataModel.h"
#import "GlobalMapping.h"

#import "TopScreen.h"
#import "MenuScreen.h"
#import "NewsScreen.h"
#import "CouponScreen.h"
#import "GalleryScreen.h"
#import "MFSideMenuContainerViewController.h"
#import "MainNavigationController.h"

#import "NewsDetailScreen.h"
#import "PhotoViewer.h"
#import "CouponDetailScreen.h"
#import "ItemDetailScreen.h"
#import "StaffDetailScreen.h"
#import "ItemDetailScreen_t2.h"
#import "UserHomeScreen.h"
#import "UserHomeScreen_t2.h"
#import "StaffDetailScreen_t2.h"
#import "UIFont+Themify.h"

#import "UserData.h"

#import "SettingsEditProfileScreen.h"

#define GRAND_IDENTIFIER_NEWS_DETAIL    @"grand_news_detail"
#define GRAND_IDENTIFIER_PHOTO_DETAIL    @"grand_photo_detail"
#define GRAND_IDENTIFIER_COUPON_DETAIL    @"grand_coupon_detail"
#define GRAND_IDENTIFIER_ITEM_DETAIL    @"grand_item_detail"

@interface GrandViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) NSMutableDictionary *cachedChildController;
@property (strong, nonatomic) UIViewController *currentChildController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UIView *childContainerView;
@end

@implementation GrandViewController

-(IBAction)buttonClick:(id)sender{
    if (sender == _menuButton) {
        if ([self.navigationController isKindOfClass:[MainNavigationController class]]) {
            [((MainNavigationController *)self.navigationController) toogleMenu];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_cachedChildController == nil) {
        _cachedChildController = [NSMutableDictionary new];
    }
    
    [self setNavigationBarStyle:NavigationBarStyleDefault];
    
}

- (void)setNavigationBarStyle:(NavigationBarStyle)style{
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *settings = [appConfig getAvailableAppSettings];

    switch (style) {
        case NavigationBarStyleDefault:{
            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:nil];
            [_menuButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIFont themifyFontOfSize:20/*[UIUtils getTextSizeWithType:settings.font_size]*/], NSFontAttributeName,
                                                 [UIColor colorWithHexString:settings.menu_icon_color], NSForegroundColorAttributeName,
                                                 nil]
                                       forState:UIControlStateNormal];
            [_menuButton setTitle:[NSString stringWithFormat: [UIFont stringForThemifyIdentifier:@"ti-menu"]]];
            self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:settings.header_color];
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            self.navigationController.navigationBar.translucent = NO;
            _navigationTitle.numberOfLines = 1;
            _navigationTitle.minimumFontSize = 10;
            _navigationTitle.adjustsFontSizeToFitWidth = YES;
            [_navigationTitle setTextColor:[UIColor colorWithHexString:settings.title_color]];
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
            
            if (settings.template_id == 1) {
                UIBarButtonItem *settingProfile = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(showUserEditProfile)];
                self.navigationItem.rightBarButtonItem = settingProfile;
                [settingProfile setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        [UIFont themifyFontOfSize:20], NSFontAttributeName,
                                                        [UIColor colorWithHexString:@"FFFFFF"], NSForegroundColorAttributeName,
                                                        nil]
                                              forState:UIControlStateNormal];
                [settingProfile setTitle:[NSString stringWithFormat: [UIFont stringForThemifyIdentifier:@"ti-settings"]]];
            }
            
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

- (void)showUserEditProfile{
    SettingsEditProfileScreen *screen = [SettingsEditProfileScreen new];
    
    [self.navigationController pushViewController:screen animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(_currentChildController == nil){
        [self showLoadingViewWithMessage:@""];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SideMenuDelegate
- (void)didSelectSideMenuItem:(NSObject *)item{
    
    [self removeLoadingView];
    
    if ([item isKindOfClass:[MenuModel class]]) {
        MenuModel *menuItem = (MenuModel *)item;
        [self showChildViewControllerWithId:menuItem.menu_id];
    }else if ([item isKindOfClass:[UserModel class]]){
        UserData *userData = [UserData shareInstance];
        if ([userData getToken] != nil) {
            [self showChildViewControllerWithId:APP_MENU_USER_HOME];
            //[self showChildViewControllerWithId:APP_MENU_SETTING];
        }else{
            [self showLogin];
        }
    }
}

#pragma mark - Private Methods
- (UIViewController *)childViewControllerWithId:(NSInteger)childId{
    UIViewController *child = nil;
    for (NSNumber *key in _cachedChildController.allKeys) {
        if ([key isEqual: @(childId)]) {
            child = [_cachedChildController objectForKey:key];
            return child;
        }
    }
    
    if (!child) {
        Bundle *extra = [Bundle new];
        [extra put:VC_EXTRA_NAVIGATION value:self.navigationController];
        child = [GlobalMapping getViewControllerWithId:childId withExtraData:extra];
        if(!child){
            return nil;
        }
        [_cachedChildController setObject:child forKey:@(childId)];
    }
    
    return child;
}

- (void)setNavigationBarTitle:(NSString *)title{
    if (_navigationTitle != nil) {
        [_navigationTitle setText:title];
    }
}

- (void)showChildViewControllerWithId:(NSInteger)childId{
    
    if (childId == -1 ) // Sign Out
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告"
                                                             message:@"アプリをサインアウトですか？"
                                                            delegate:self
                                                   cancelButtonTitle:@"閉じる"
                                                   otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    UIViewController *child = [self childViewControllerWithId:childId];
    if(child != nil){
        [self presentChildViewController:child];
        if (child.title != nil) {
            [self setNavigationBarTitle:child.title];
        }

    }else {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                           message:@"This feature is under development"
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(buttonIndex) {
        case 0: //"No" pressed
            //do something?
            break;
        case 1: //"Yes" pressed
            [self signOut];
            break;
    }
}


- (void)presentChildViewController:(UIViewController *)child{
    if (self.currentChildController) {
        [self.currentChildController.view removeFromSuperview];
        [self.currentChildController removeFromParentViewController];
    }

    self.currentChildController = child;
    child.view.frame = self.view.bounds;
    [self.view addSubview:child.view];
    [self addChildViewController:child];
    [child didMoveToParentViewController:self];
}

- (void)performSegueWithObject:(NSObject *)object{
    if (!object) {
        return;
    }
    
    AppSettings *settings = [[AppConfiguration sharedInstance] getAvailableAppSettings];
    
    if ([object isKindOfClass:[NewsObject class]]) {
        [self performSegueWithIdentifier:GRAND_IDENTIFIER_NEWS_DETAIL sender:object];
    }else if ([object isKindOfClass:[CouponObject class]]){
        [self performSegueWithIdentifier:GRAND_IDENTIFIER_COUPON_DETAIL sender:object];
    }else if ([object isKindOfClass:[PhotoObject class]]){
        //[self performSegueWithIdentifier:GRAND_IDENTIFIER_PHOTO_DETAIL sender:object];
        PhotoObject *photo = (PhotoObject *)object;
        Bundle *extra = [Bundle new];
        [extra put:PhotoViewer_PHOTO value:photo];
        UIViewController *photoViewer = [GlobalMapping getPhotoViewer:settings.template_id andExtra:extra];
        [self presentViewController:photoViewer animated:YES completion:nil];
        return;
    }else if ([object isKindOfClass:[ProductObject class]]){
        if (settings.template_id == 1) {
            [self performSegueWithIdentifier:GRAND_IDENTIFIER_ITEM_DETAIL sender:object];
        }else{
            ProductObject *item = (ProductObject *)object;
            ItemDetailScreen_t2 *controller = [[ItemDetailScreen_t2 alloc] initWithItem:item];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if([object isKindOfClass:[StaffObject class]]){
        StaffObject *staff = (StaffObject *)object;
        if (settings.template_id == 1) {
            StaffDetailScreen *controller = [[StaffDetailScreen alloc] initWithStaff:staff];
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            StaffDetailScreen_t2 *controller = [[StaffDetailScreen_t2 alloc] initWithStaff:staff];
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:GRAND_IDENTIFIER_NEWS_DETAIL]) {
        NewsObject *news = (NewsObject *)sender;
        NewsDetailScreen *newsDetail = segue.destinationViewController;
        newsDetail.news = news;
    }else if ([segue.identifier isEqualToString:GRAND_IDENTIFIER_PHOTO_DETAIL]){
        PhotoViewer *viewer = (PhotoViewer *)segue.destinationViewController;
        [viewer setPhoto:(PhotoObject *)sender];
    }else if ([segue.identifier isEqualToString:GRAND_IDENTIFIER_COUPON_DETAIL]){
        CouponObject *coupon = (CouponObject *)sender;
        CouponDetailScreen *couponDetail = (CouponDetailScreen *)segue.destinationViewController;
        couponDetail.coupon = coupon;
    }else if ([segue.identifier isEqualToString:GRAND_IDENTIFIER_ITEM_DETAIL]){
        ProductObject *item = (ProductObject *)sender;
        ItemDetailScreen *itemDetail = (ItemDetailScreen *)segue.destinationViewController;
        itemDetail.item = item;
    }
}

@end
