//
//  GlobalMapping.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/30/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Bundle.h"

#define VC_EXTRA_NAVIGATION @"navigation_controller"

#define Template_TopScreen          @"TopScreen"
#define Template_MenuScreen         @"MenuScreen"
#define Template_NewsScreen         @"NewsScreen"
#define Template_CouponScreen       @"CouponScreen"
#define Template_GalleryScreen      @"GalleryScreen"
#define Template_ReserveScreen      @"ReserveScreen"
#define Template_SettingsScreen     @"SettingsScreen"
#define Template_StaffScreen        @"StaffScreen"
#define Template_ChatScreen         @"ChatScreen"
#define Template_UserHomeScreen     @"UserHomeScreen"
#define Template_SettingHomeScreen  @"SettingHomeScreen"
#define Template_LoginScreen        @"LoginScreen"

#define PhotoViewer_PHOTO           @"PhotoViewer_PHOTO"

@interface GlobalMapping : NSObject

+ (UIViewController *)getViewControllerWithId:(NSInteger)viewControlerId withExtraData:(Bundle *)extra;

+ (UIViewController *)getLoginScreenWithNavigation;

+ (UIViewController *)getScreenFromTemplateName:(NSString *)templateName;


+ (UIViewController *)getStaffScreen:(NSInteger) templateId andExtra:(Bundle *)extra;
+ (UIViewController *)getNewsScreen:(NSInteger) templateId andExtra:(Bundle *)extra;
+ (UIViewController *)getMenuScreen:(NSInteger) templateId andExtra:(Bundle *)extra;
+ (UIViewController *)getHomeScreen:(NSInteger)templateId andExtra:(Bundle *)extra;
+ (UIViewController *)getUserHomeScreen:(NSInteger) templateId andExtra:(Bundle *)extra;
+ (UIViewController *)getCouponScreen:(NSInteger) templateId andExtra:(Bundle *)extra;
+ (UIViewController *)getGalleryScreen:(NSInteger) templateId andExtra:(Bundle *)extra;
+ (UIViewController *)getShareAppScreen:(NSInteger) templateId andExtra:(Bundle *)extra;
+ (UIViewController *)getPhotoViewer:(NSInteger) templateId andExtra:(Bundle *)extra;
+ (UIViewController *)getCouponRequestWaitScreen:(NSInteger) templateId andExtra:(Bundle *)extra;

@end
