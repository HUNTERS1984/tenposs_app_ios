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

@interface AppInfo : JSONModel

@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *logn;
@property (strong, nonatomic) NSString *tel;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *start_time;
@property (strong, nonatomic) NSString *end_time;

@end

@interface AppSettings : JSONModel

/*
 *  Navigation bar properties
 */
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *title_color;
@property (assign, nonatomic) int font_size;
@property (strong, nonatomic) NSString *font_family;
@property (strong, nonatomic) NSString *header_color;

/*
 *  Menu properties
 */
@property (strong, nonatomic) NSString *menu_icon_color;
@property (strong, nonatomic) NSString *menu_background_color;
@property (strong, nonatomic) NSString *menu_font_color;
@property (assign, nonatomic) int menu_font_size;
@property (strong, nonatomic) NSString *menu_font_family;
@property (assign, nonatomic) int template_id;
@property (strong, nonatomic) NSString *top_main_image_url;

@end

@interface MenuModel : JSONModel

@property (assign, nonatomic)NSInteger menu_id;
@property (strong, nonatomic) NSString *title;
@end

typedef void (^AppConfigurationCompleteHandler)(NSError *error);

@interface AppConfiguration : NSObject
/*
 *  CollectionView properties
 */
@property (assign, nonatomic) CGFloat cellSpacing;
@property (assign, nonatomic) NSInteger numberOfProductColumn_iphone;
@property (assign, nonatomic) NSInteger numberOfProductColumn_ipad;
@property (assign, nonatomic) NSInteger numberOfPhotoColumn_iphone;
@property (assign, nonatomic) NSInteger numberOfPhotoColumn_ipad;

@property (strong, nonatomic) AppSettings *appSettings;
@property (strong, nonatomic) AppInfo *appInfo;
@property (strong, nonatomic) NSMutableArray <MenuModel *> *menuData;

@property (copy) AppConfigurationCompleteHandler completeHandler;

+ (instancetype) sharedInstance;

- (void)loadAppInfoWithCompletionHandler:(void(^)(NSError *error))handler;


@end
