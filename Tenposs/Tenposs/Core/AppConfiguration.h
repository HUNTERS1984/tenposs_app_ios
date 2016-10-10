//
//  AppConfiguration.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/26/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSONModel.h"

@class AppSettings;
@class TopComponentModel;
@class MenuModel;
@class StoreModel;

@protocol TopComponentModel
@end

@protocol MenuModel
@end

@protocol StoreModel
@end

#define APP_MENU_TOP                 6
#define APP_MENU_MENU                2
#define APP_MENU_RESERVE             4
#define APP_MENU_NEWS                3
#define APP_MENU_PHOTO_GALLERY       5
#define APP_MENU_STAFF               8
#define APP_MENU_COUPON              9
#define APP_MENU_CHAT                7
#define APP_MENU_SETTING             10
#define APP_MENU_IMAGES              1
#define APP_MENU_LOGOUT             -1

@interface AppInfo : JSONModel

//@property (strong, nonatomic) NSString *lat;
//@property (strong, nonatomic) NSString *logn;
//@property (strong, nonatomic) NSString *tel;
//@property (strong, nonatomic) NSString *title;
//@property (strong, nonatomic) NSString *start_time;
//@property (strong, nonatomic) NSString *end_time;

@property (assign, nonatomic) NSInteger store_id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *created_at;
@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic) NSString *updated_at;

@property (strong, nonatomic) AppSettings *app_setting;

@property (strong, nonatomic) NSMutableArray <ConvertOnDemand, TopComponentModel> *top_components;

@property (strong, nonatomic)NSMutableArray <ConvertOnDemand, MenuModel> *side_menu;

@property (strong, nonatomic)NSMutableArray <ConvertOnDemand, StoreModel> *stores;

@end

@interface AppSettings : JSONModel

/*
 * General
 */
@property (assign, nonatomic) NSInteger app_id;

/*
 *  Navigation bar properties
 */
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *title_color;
@property (strong, nonatomic) NSString *font_size;
@property (strong, nonatomic) NSString *font_family;
@property (strong, nonatomic) NSString *header_color;

/*
 *  Menu properties
 */
@property (strong, nonatomic) NSString *menu_icon_color;
@property (strong, nonatomic) NSString *menu_background_color;
@property (strong, nonatomic) NSString *menu_font_color;
@property (strong, nonatomic) NSString *menu_font_size;
@property (strong, nonatomic) NSString *menu_font_family;
@property (assign, nonatomic) int template_id;

@property (strong, nonatomic) NSString *company_info;
@property (strong, nonatomic) NSString *user_privacy;

@end

@interface MenuModel : JSONModel

@property (assign, nonatomic)NSInteger menu_id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *icon;
@end

@interface TopComponentModel : JSONModel
@property (assign, nonatomic) NSInteger top_id;
@property (strong, nonatomic) NSString *name;
@end

@interface StoreModel : JSONModel
@property (assign, nonatomic)NSInteger store_id;
@property (strong, nonatomic) NSString *name;
@end

typedef void (^AppConfigurationCompleteHandler)(NSError *error);

@interface AppConfiguration : NSObject
/*
 *  CollectionView properties
 */

@property (copy) AppConfigurationCompleteHandler completeHandler;

+ (instancetype) sharedInstance;

- (void)loadAppInfoWithCompletionHandler:(void(^)(NSError *error))handler;

- (NSArray <TopComponentModel *> *) getAvailableTopComponents;
- (NSArray<MenuModel *> *) getAvailableSideMenu;
- (AppSettings *)getAvailableAppSettings;
- (NSString *)getStoreId;
-(NSArray *)getStoryIdArray;

@end
