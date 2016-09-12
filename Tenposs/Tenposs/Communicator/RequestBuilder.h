//
//  RequestBuilder.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/6/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bundle.h"

/*
 * URL
 */
extern NSString * const BASE_ADDRESS;
extern NSString * const API_ADDRESS;
extern NSString * const API_LOGIN;
extern NSString * const API_SLOGIN;
extern NSString * const API_SIGNUP;
extern NSString * const API_LOGOUT;
extern NSString * const API_TOP;
extern NSString * const API_MENU;
extern NSString * const API_APPINFO;
extern NSString * const API_ITEMS;
extern NSString * const API_ITEMS_DETAIL;
extern NSString * const API_ITEMS_RELATE;
extern NSString * const API_PHOTO_CAT;
extern NSString * const API_PHOTO;
extern NSString * const API_NEWS;
extern NSString * const API_NEWS_DETAIL;
extern NSString * const API_RESERVE;
extern NSString * const API_COUPON;
extern NSString * const API_COUPON_DETAIL;
extern NSString * const API_APPUSER;
extern NSString * const API_SETPUSHKEY;
extern NSString * const API_UPDATE_PROFILE;
extern NSString * const KeyAPI_USERNAME_NAME;
/*
 * API request key
 */
extern NSString * const KeyAPI_APP_ID;
extern NSString * const KeyAPI_TIME;
extern NSString * const KeyAPI_SIG;
extern NSString * const KeyAPI_STORE_ID;
extern NSString * const KeyAPI_APP_ID;
extern NSString * const KeyAPI_APP_ID;
extern NSString * const KeyAPI_EMAIL;
extern NSString * const KeyAPI_PASSWORD;
extern NSString * const KeyAPI_SOCIAL_TYPE;
extern NSString * const KeyAPI_SOCIAL_ID;
extern NSString * const KeyAPI_SOCIAL_TOKEN;
extern NSString * const KeyAPI_SOCIAL_SECRET;
extern NSString * const KeyAPI_TOKEN;
extern NSString * const KeyAPI_PAGE_INDEX;
extern NSString * const KeyAPI_PAGE_SIZE;
extern NSString * const KeyAPI_MENU_ID;
extern NSString * const KeyAPI_ITEM_ID;
extern NSString * const KeyAPI_CATEGORY_ID;
extern NSString * const KeyAPI_COUPON_ID;
extern NSString * const KeyAPI_USERNAME;
extern NSString * const KeyAPI_GENDER;
extern NSString * const KeyAPI_ADDRESS;
extern NSString * const KeyAPI_AVATAR;
extern NSString * const KeyAPI_CLIENT;
extern NSString * const KeyAPI_KEY;
extern NSString * const KeyAPI_RANKING;
extern NSString * const KeyAPI_NEWS;
extern NSString * const KeyAPI_COUPON;
extern NSString * const KeyAPI_CHAT;
extern NSString * const API_STAFF;
extern NSString * const API_STAFF_CAT;


@interface RequestBuilder : NSObject

+ (NSString *)getImageRequestURL:(NSString *)imageURL;

+ (NSString *)APIAddress;

+(NSString*) requestBuilder:(Bundle *)params;

@end
