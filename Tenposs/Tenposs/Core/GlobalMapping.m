//
//  GlobalMapping.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/30/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "GlobalMapping.h"
#import "AppConfiguration.h"
#import "UIUtils.h"
#import "TopScreen.h"
#import "MenuScreen.h"
#import "NewsScreen.h"
#import "CouponScreen.h"
#import "GalleryScreen.h"
#import "ReserveScreen.h"
#import "SettingsScreen.h"
#import "StaffScreen.h"
#import "ChatScreen.h"
#import "UserHomeScreen.h"

#import "TabDataSourceViewController.h"

@implementation GlobalMapping

+(UIViewController *)getViewControllerWithId:(NSInteger)viewControlerId withExtraData:(Bundle *)extra{
    UIStoryboard *storyboard = [UIUtils mainStoryboard];
    UIViewController *viewController = nil;
    UINavigationController *navigationController = nil;
    if ([extra get:VC_EXTRA_NAVIGATION]) {
        navigationController = (UINavigationController *)[extra get:VC_EXTRA_NAVIGATION];
    }
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    
    if(viewControlerId == APP_MENU_TOP){
        viewController = [[TopScreen alloc]initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
        ((TopScreen *)viewController).mainNavigationController = navigationController;
    }else if (viewControlerId == APP_MENU_NEWS){
//        viewController = (NewsScreen *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NewsScreen class])];
//        ((NewsScreen *)viewController).mainNavigationController = navigationController;
        viewController = (TabDataSourceViewController *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TabDataSourceViewController class])];
        [((TabDataSourceViewController *)viewController) setControllerType:TABVIEWCONTROLLER_News];
        ((TabDataSourceViewController *)viewController).mainNavigationController = navigationController;
    }else if (viewControlerId == APP_MENU_MENU){
//        viewController = (MenuScreen *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MenuScreen class])];
//        ((MenuScreen *)viewController).mainNavigationController = navigationController;
        
        viewController = (TabDataSourceViewController *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TabDataSourceViewController class])];
        [((TabDataSourceViewController *)viewController) setControllerType:TABVIEWCONTROLLER_Menu];
        ((TabDataSourceViewController *)viewController).mainNavigationController = navigationController;
        
    }else if (viewControlerId == APP_MENU_COUPON){
        viewController = (CouponScreen *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CouponScreen class])];
        ((CouponScreen *)viewController).mainNavigationController = navigationController;
        ((CouponScreen *)viewController).store_id = [[appConfig getStoreId] integerValue];
    }else if (viewControlerId == APP_MENU_PHOTO_GALLERY){
//        viewController = (GalleryScreen *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([GalleryScreen class])];
//        ((GalleryScreen *)viewController).mainNavigationController = navigationController;
        viewController = (TabDataSourceViewController *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TabDataSourceViewController class])];
        [((TabDataSourceViewController *)viewController) setControllerType:TABVIEWCONTROLLER_Gallery];
        ((TabDataSourceViewController *)viewController).mainNavigationController = navigationController;
    }else if (viewControlerId == APP_MENU_RESERVE){
        viewController = (ReserveScreen *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ReserveScreen class])];
    }else if (viewControlerId == APP_MENU_SETTING){
        viewController = (SettingsScreen *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SettingsScreen class])];
    }else if (viewControlerId == APP_MENU_STAFF){
//        viewController = (StaffScreen *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([StaffScreen class])];
//        ((StaffScreen *)viewController).mainNavigationController = navigationController;
        viewController = (TabDataSourceViewController *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TabDataSourceViewController class])];
        [((TabDataSourceViewController *)viewController) setControllerType:TABVIEWCONTROLLER_Staff];
        ((TabDataSourceViewController *)viewController).mainNavigationController = navigationController;
    }else if (viewControlerId == APP_MENU_CHAT){
        viewController = (ChatScreen *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ChatScreen class])];
    }else if(viewControlerId == APP_MENU_USER_HOME){
        viewController = (UserHomeScreen *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([UserHomeScreen class])];
    }
    return viewController;
}

@end
