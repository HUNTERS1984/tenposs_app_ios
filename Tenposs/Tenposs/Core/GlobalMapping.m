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
#import "HexColors.h"

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
#import "SettingHomeScreen.h"
#import "LoginScreen.h"
#import "TabDataSourceViewController.h"

#import "WrapperLoginWithFixedBackground.h"
#import "MenuScreen_t2.h"
#import "UserHomeScreen_t2.h"
#import "NewsScreenDetailDataSource_t2.h"
#import "BasicCollectionViewController.h"
#import "StaffScreenDetailDataSource_t2.h"
#import "CouponScreen_t2.h"
#import "GalleryScreen_t2.h"
#import "ShareAppScreen.h"
#import "ShareAppScreen_t2.h"
#import "PhotoViewer.h"
#import "PhotoViewerScreen_t2.h"
#import "CouponRequestWaitScreen.h"


@implementation GlobalMapping

+(UIViewController *)getViewControllerWithId:(NSInteger)viewControlerId withExtraData:(Bundle *)extra{
    UIStoryboard *storyboard = [UIUtils mainStoryboard];
    UIViewController *viewController = nil;
    UINavigationController *navigationController = nil;
    if ([extra get:VC_EXTRA_NAVIGATION]) {
        navigationController = (UINavigationController *)[extra get:VC_EXTRA_NAVIGATION];
    }
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *settings = [appConfig getAvailableAppSettings];
    
    if(viewControlerId == APP_MENU_TOP){
        viewController = [self getHomeScreen:settings.template_id andExtra:extra];
    }else if (viewControlerId == APP_MENU_NEWS){
        viewController = [self getNewsScreen:settings.template_id andExtra:extra];
    }else if (viewControlerId == APP_MENU_MENU){
        viewController = [self getMenuScreen:settings.template_id andExtra:extra];
    }else if (viewControlerId == APP_MENU_COUPON){
        viewController = [self getCouponScreen:settings.template_id andExtra:extra];
    }else if (viewControlerId == APP_MENU_PHOTO_GALLERY){
        viewController = [self getGalleryScreen:settings.template_id andExtra:extra];
    }else if (viewControlerId == APP_MENU_RESERVE){
        viewController = (ReserveScreen *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ReserveScreen class])];
    }else if (viewControlerId == APP_MENU_SETTING){
        viewController = [self getSettingsHomeScreen:settings.template_id andExtra:extra];
    }else if (viewControlerId == APP_MENU_STAFF){
        viewController = [self getStaffScreen:settings.template_id andExtra:extra];
    }else if (viewControlerId == APP_MENU_CHAT){
        viewController = (ChatScreen *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ChatScreen class])];
    }else if(viewControlerId == APP_MENU_USER_HOME){
        viewController = [self getUserHomeScreen:settings.template_id andExtra:extra];
    }
    return viewController;
}

+ (UIViewController *)getScreenFromTemplateName:(NSString *)templateName{
    NSString *screenName = nil;
    AppSettings *settings = [[AppConfiguration sharedInstance] getAvailableAppSettings];
    screenName = [self screenName:templateName WithTemplateId:settings.template_id];
    UIStoryboard *storyboard = [self mainStoryboardWithTemplateId:settings.template_id];
    if (screenName) {
        UIViewController *screen = [storyboard instantiateViewControllerWithIdentifier:screenName];
        return screen;
    }
    return nil;
}

+ (UIViewController *)getLoginScreenWithNavigation{
    AppSettings *settings = [[AppConfiguration sharedInstance] getAvailableAppSettings];
    
    if (settings && settings.template_id) {
        UIStoryboard *storyboard = [self mainStoryboardWithTemplateId:settings.template_id];
        if (settings.template_id == 1) {
            LoginScreen *nextController = [storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:nextController];
            [navi.navigationBar setHidden:YES];
            return navi;
        }else if(settings.template_id == 2) {
            WrapperLoginWithFixedBackground *controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([WrapperLoginWithFixedBackground class])];
            return controller;
        }
    }
    return nil;
}

+ (UIViewController *)getSettingsHomeScreen:(NSInteger) templateId andExtra:(Bundle *)extra{
    UIViewController *viewController = nil;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    viewController = (SettingHomeScreen *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SettingHomeScreen class])];
    return viewController;
}

+ (UIViewController *)getUserHomeScreen:(NSInteger) templateId andExtra:(Bundle *)extra{
    UIViewController *viewController = nil;
    UIStoryboard *storyboard = [self mainStoryboardWithTemplateId:templateId];
    switch (templateId) {
        case 1:{
            viewController = (UserHomeScreen *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([UserHomeScreen class])];
        }
            break;
        case 2:{
            viewController = (UserHomeScreen_t2 *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([UserHomeScreen_t2 class])];
        }
            break;
        default:
            break;
    }
    return viewController;
}

+ (UIViewController *)getHomeScreen:(NSInteger)templateId andExtra:(Bundle *)extra{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = nil;
    UINavigationController *navigationController = nil;
    if ([extra get:VC_EXTRA_NAVIGATION]) {
        navigationController = (UINavigationController *)[extra get:VC_EXTRA_NAVIGATION];
    }
    switch (templateId) {
        case 1:
        case 2:{
            viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TopScreen class])];
            ((TopScreen *)viewController).mainNavigationController = navigationController;
        }
            break;
        default:
            break;
    }
    return viewController;
}

+ (UIViewController *)getMenuScreen:(NSInteger) templateId andExtra:(Bundle *)extra{
    UIViewController *viewController = nil;
    UINavigationController *navigationController = nil;
    if ([extra get:VC_EXTRA_NAVIGATION]) {
        navigationController = (UINavigationController *)[extra get:VC_EXTRA_NAVIGATION];
    }
    UIStoryboard *storyboard = [self mainStoryboardWithTemplateId:templateId];
    switch (templateId) {
        case 1:{
            viewController = (TabDataSourceViewController *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TabDataSourceViewController class])];
            [((TabDataSourceViewController *)viewController) setControllerType:TABVIEWCONTROLLER_Menu];
            if (navigationController) {
             ((TabDataSourceViewController *)viewController).mainNavigationController = navigationController;
            }else{
                NSAssert(NO, @"Should have a NavigationController reference");
            }
        }
            break;
        case 2:{
            viewController = [[MenuScreen_t2 alloc] init];
            ((MenuScreen_t2 *)viewController).mainNavigationController = navigationController;
        }
            break;
        default:
            break;
    }
    return viewController;
}

+ (UIViewController *)getNewsScreen:(NSInteger) templateId andExtra:(Bundle *)extra{
    UIViewController *viewController = nil;
    UINavigationController *navigationController = nil;
    if ([extra get:VC_EXTRA_NAVIGATION]) {
        navigationController = (UINavigationController *)[extra get:VC_EXTRA_NAVIGATION];
    }
    UIStoryboard *storyboard = [self mainStoryboardWithTemplateId:templateId];
    switch (templateId) {
        case 1:{
            viewController = (TabDataSourceViewController *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TabDataSourceViewController class])];
            [((TabDataSourceViewController *)viewController) setControllerType:TABVIEWCONTROLLER_News];
            if (navigationController) {
                ((TabDataSourceViewController *)viewController).mainNavigationController = navigationController;
            }
        }
            break;
        case 2:{
            ///TODO: new NewsDetailDataSource
            NewsCategoryObject *newsCate = [NewsCategoryObject new];
            newsCate.category_id = 0;
            NewsScreenDetailDataSource_t2 *dataSource = [[NewsScreenDetailDataSource_t2 alloc] initWithNewsCategory:newsCate];
            viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BasicCollectionViewController class])];
            ((BasicCollectionViewController *)viewController).dataSource = dataSource;
            ((BasicCollectionViewController *)viewController).bkgColor = [UIColor colorWithHexString:@"#FFFFFF"];
            viewController.title = @"ニュース";
        }
            break;
        default:
            break;
    }
    return viewController;
}

+ (UIViewController *)getStaffScreen:(NSInteger) templateId andExtra:(Bundle *)extra{
    UIViewController *viewController = nil;
    UINavigationController *navigationController = nil;
    if ([extra get:VC_EXTRA_NAVIGATION]) {
        navigationController = (UINavigationController *)[extra get:VC_EXTRA_NAVIGATION];
    }
    UIStoryboard *storyboard = [self mainStoryboardWithTemplateId:templateId];
    switch (templateId) {
        case 1:{
            viewController = (TabDataSourceViewController *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TabDataSourceViewController class])];
            [((TabDataSourceViewController *)viewController) setControllerType:TABVIEWCONTROLLER_Staff];
            if (navigationController) {
                ((TabDataSourceViewController *)viewController).mainNavigationController = navigationController;
            }
        }
            break;
        case 2:{
            StaffCategory *staffCate = [[StaffCategory alloc] init];
            staffCate.staff_cate_id = 0;
            staffCate.pageindex = 1;
            StaffScreenDetailDataSource_t2 *dataSource = [[StaffScreenDetailDataSource_t2 alloc] initWithStaffCategory:staffCate];
            viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BasicCollectionViewController class])];
            ((BasicCollectionViewController *)viewController).dataSource = dataSource;
            ((BasicCollectionViewController *)viewController).bkgColor = [UIColor colorWithHexString:@"#FFFFFF"];
            viewController.title = @"スタッフ";
        }
            break;
        default:
            break;
    }
    return viewController;
}

+ (UIViewController *)getGalleryScreen:(NSInteger) templateId andExtra:(Bundle *)extra{
    UIViewController *viewController = nil;
    UINavigationController *navigationController = nil;
    if ([extra get:VC_EXTRA_NAVIGATION]) {
        navigationController = (UINavigationController *)[extra get:VC_EXTRA_NAVIGATION];
    }
    UIStoryboard *storyboard = [self mainStoryboardWithTemplateId:templateId];
    switch (templateId) {
        case 1:{
            viewController = (TabDataSourceViewController *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TabDataSourceViewController class])];
            [((TabDataSourceViewController *)viewController) setControllerType:TABVIEWCONTROLLER_Gallery];
            if (navigationController) {
                ((TabDataSourceViewController *)viewController).mainNavigationController = navigationController;
            }
        }
            break;
        case 2:{
            viewController = (GalleryScreen_t2 *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([GalleryScreen_t2 class])];
        }
            break;
        default:
            break;
    }
    return viewController;
}



+ (UIViewController *)getCouponScreen:(NSInteger) templateId andExtra:(Bundle *)extra{
    UIViewController *viewController = nil;
    UINavigationController *navigationController = nil;
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    if ([extra get:VC_EXTRA_NAVIGATION]) {
        navigationController = (UINavigationController *)[extra get:VC_EXTRA_NAVIGATION];
    }
    UIStoryboard *storyboard = [self mainStoryboardWithTemplateId:templateId];
    switch (templateId) {
        case 1:{
            viewController = (CouponScreen *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CouponScreen class])];
            ((CouponScreen *)viewController).mainNavigationController = navigationController;
            ((CouponScreen *)viewController).store_id = [[appConfig getStoreId] integerValue];
        }
            break;
        case 2:{
            StaffCategory *staffCate = [[StaffCategory alloc] init];
            staffCate.staff_cate_id = 0;
            staffCate.pageindex = 1;
            viewController = (CouponScreen_t2 *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CouponScreen_t2 class])];
            ((CouponScreen_t2 *)viewController).mainNavigationController = navigationController;
            ((CouponScreen_t2 *)viewController).store_id = [[appConfig getStoreId] integerValue];
            ((CouponScreen_t2 *)viewController).staffCate = staffCate;
        }
            break;
        default:
            break;
    }
    return viewController;
}

+ (UIViewController *)getShareAppScreen:(NSInteger) templateId andExtra:(Bundle *)extra{
    UIViewController *viewController = nil;
    UINavigationController *navigationController = nil;
    if (extra && [extra get:VC_EXTRA_NAVIGATION]) {
        navigationController = (UINavigationController *)[extra get:VC_EXTRA_NAVIGATION];
    }
    UIStoryboard *storyboard = [self mainStoryboardWithTemplateId:templateId];
    switch (templateId) {
        case 1:{
            viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ShareAppScreen class])];
            viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        }
            break;
        case 2:{
            ///TODO: new NewsDetailDataSource
            viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ShareAppScreen_t2 class])];
            viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        }
            break;
        default:
            break;
    }
    return viewController;
}

+ (UIViewController *)getPhotoViewer:(NSInteger) templateId andExtra:(Bundle *)extra{
    UIViewController *viewController = nil;
    UINavigationController *navigationController = nil;
    if (extra && [extra get:PhotoViewer_PHOTO]) {
        PhotoObject *photo = (PhotoObject *)[extra get:PhotoViewer_PHOTO];
        if (!photo) {
            return nil;
        }
        if ([extra get:VC_EXTRA_NAVIGATION]) {
            navigationController = (UINavigationController *)[extra get:VC_EXTRA_NAVIGATION];
        }
        UIStoryboard *storyboard = [self mainStoryboardWithTemplateId:templateId];
        switch (templateId) {
            case 1:{
                viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([PhotoViewer class])];
                [((PhotoViewer *)viewController) setPhoto:photo];
                viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            }
                break;
            case 2:{
                ///TODO: new NewsDetailDataSource
                viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([PhotoViewerScreen_t2 class])];
                [((PhotoViewerScreen_t2 *)viewController) setPhoto:photo];
                viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            }
                break;
            default:
                break;
        }
    }else{
        return nil;
    }
    return viewController;
}

+ (UIViewController *)getCouponRequestWaitScreen:(NSInteger) templateId andExtra:(Bundle *)extra{
    UIViewController *viewController = nil;
    UINavigationController *navigationController = nil;
    if (extra && [extra get:VC_EXTRA_NAVIGATION]) {
        navigationController = (UINavigationController *)[extra get:VC_EXTRA_NAVIGATION];
    }
    UIStoryboard *storyboard = [self mainStoryboardWithTemplateId:templateId];
    switch (templateId) {
        case 1:{
            //                viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CouponRequestWaitScreen class])];
            //                     viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            //                viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            return nil;
        }
            break;
        case 2:{
            ///TODO: new NewsDetailDataSource
            viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CouponRequestWaitScreen class])];
            viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        }
            break;
        default:
            break;
    }
    return viewController;
}


+ (NSString *)screenName:(NSString *)screenName WithTemplateId:(NSInteger)template{
    if (template == 1) {
        return screenName;
    }else{
        return [NSString stringWithFormat:@"%@_t%@",screenName,[@(template) stringValue]];
    }
}

+(UIStoryboard *)mainStoryboardWithTemplateId:(NSInteger)template{
    NSString *name = nil;
    if (template == 1) {
        name = @"Main";
    }else{
        name = [NSString stringWithFormat:@"Main_t%@",[@(template) stringValue]];
    }
    
    if (name) {
        return [UIStoryboard storyboardWithName:name bundle:nil];
    }
    return nil;
}

@end
