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

@interface GrandViewController (){
    UILabel *navigationTitle;
}

@property (strong, nonatomic) NSMutableDictionary *cachedChildController;
@property (strong, nonatomic) UIViewController *currentChildController;
@end

@implementation GrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_cachedChildController == nil) {
        _cachedChildController = [NSMutableDictionary new];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_currentChildController == nil){
        [self showLoadingViewWithMessage:@""];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *settings = [appConfig getAvailableAppSettings];
    
    if (self.navigationItem != nil && self.navigationItem.titleView == nil) {
        if (navigationTitle == nil) {
            navigationTitle = [UILabel new];
            if (settings && settings.title_color && ![settings.title_color isEqualToString:@""]) {
                [navigationTitle setTextColor:[UIColor colorWithHexString:settings.title_color]];
            }else{
                //TODO: need default value
            }
        }
        [self.navigationItem setTitleView:navigationTitle];
    }
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

- (void)showChildViewControllerWithId:(NSInteger)childId{
    UIViewController *child = [self childViewControllerWithId:childId];
    
    if(child != nil){
        [self presentChildViewController:child];
    }else {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                           message:@"This feature is under development"
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
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

@end
