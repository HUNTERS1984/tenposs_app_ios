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
#import "UIFont+Themify.h"

#import "UserData.h"

#define GRAND_IDENTIFIER_NEWS_DETAIL    @"grand_news_detail"
#define GRAND_IDENTIFIER_PHOTO_DETAIL    @"grand_photo_detail"
#define GRAND_IDENTIFIER_COUPON_DETAIL    @"grand_coupon_detail"
#define GRAND_IDENTIFIER_ITEM_DETAIL    @"grand_item_detail"

@interface GrandViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) NSMutableDictionary *cachedChildController;
@property (strong, nonatomic) UIViewController *currentChildController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

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
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *settings = [appConfig getAvailableAppSettings];
    
    [_menuButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont themifyFontOfSize:settings.font_size], NSFontAttributeName,
                                        [UIColor colorWithHexString:settings.title_color], NSForegroundColorAttributeName,
                                        nil] 
                              forState:UIControlStateNormal];
    [_menuButton setTitle:[NSString stringWithFormat: @"\ue68e"]];
    self.navigationController.navigationBar.backgroundColor= [UIColor colorWithHexString:settings.header_color];
    [_navigationTitle setTextColor:[UIColor colorWithHexString:settings.title_color]];
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
            [self showChildViewControllerWithId:APP_MENU_SETTING];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
    [self addChildViewController:child];
    [self.view addSubview:child.view];
    [child didMoveToParentViewController:self];
}

- (void)performSegueWithObject:(NSObject *)object{
    if (!object) {
        return;
    }
    if ([object isKindOfClass:[NewsObject class]]) {
        [self performSegueWithIdentifier:GRAND_IDENTIFIER_NEWS_DETAIL sender:object];
    }else if ([object isKindOfClass:[CouponObject class]]){
        [self performSegueWithIdentifier:GRAND_IDENTIFIER_COUPON_DETAIL sender:object];
    }else if ([object isKindOfClass:[PhotoObject class]]){
        [self performSegueWithIdentifier:GRAND_IDENTIFIER_PHOTO_DETAIL sender:object];
    }else if ([object isKindOfClass:[ProductObject class]]){
        [self performSegueWithIdentifier:GRAND_IDENTIFIER_ITEM_DETAIL sender:object];
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
