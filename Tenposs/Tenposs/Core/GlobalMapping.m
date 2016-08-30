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

@implementation GlobalMapping

+(UIViewController *)getViewControllerWithId:(NSInteger)viewControlerId withExtraData:(Bundle *)extra{
    UIStoryboard *storyboard = [UIUtils mainStoryboard];
    UIViewController *viewController = nil;
    UINavigationController *navigationController = nil;
    if ([extra get:VC_EXTRA_NAVIGATION]) {
        navigationController = (UINavigationController *)[extra get:VC_EXTRA_NAVIGATION];
    }
    
    if(viewControlerId == APP_MENU_TOP){
        viewController = [[TopScreen alloc]initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
        ((TopScreen *)viewController).mainNavigationController = navigationController;
    }else if (viewControlerId == APP_MENU_NEWS){
        viewController = (NewsScreen *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NewsScreen class])];
        ((NewsScreen *)viewController).mainNavigationController = navigationController;
    }else if (viewControlerId == APP_MENU_MENU){
        viewController = (MenuScreen *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MenuScreen class])];
        ((MenuScreen *)viewController).mainNavigationController = navigationController;
    }else if (viewControlerId == APP_MENU_COUPON){
        viewController = (CouponScreen *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CouponScreen class])];
        ((CouponScreen *)viewController).mainNavigationController = navigationController;
    }else if (viewControlerId == APP_MENU_PHOTO_GALLERY){
        viewController = (GalleryScreen *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([GalleryScreen class])];
        ((GalleryScreen *)viewController).mainNavigationController = navigationController;
    }else if (viewControlerId == APP_MENU_RESERVE){
        
    }
    
    return viewController;
}

@end
