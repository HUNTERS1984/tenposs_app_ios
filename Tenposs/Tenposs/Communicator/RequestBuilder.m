//
//  RequestBuilder.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/6/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "RequestBuilder.h"
#import "NSString.h"
#import "Bundle.h"


@implementation RequestBuilder

#pragma mark - URL

NSString * const BASE_ADDRESS  =  @"http://ec2-54-204-210-230.compute-1.amazonaws.com/";
NSString * const API_BASE = @"api/v1";
NSString * const API_LOGIN  = @"/login?";
NSString * const API_SIGNUP = @"/signup?";
NSString * const API_LOGOUT  =   @"/logout?";
NSString * const API_TOP  =  @"/top?";
NSString * const API_MENU  = @"/menu?";
NSString * const API_APPINFO  =  @"/appinfo?";
NSString * const API_ITEMS  = @"/items?";
NSString * const API_ITEMS_DETAIL  = @"/items/detail?";
NSString * const API_ITEMS_RELATE  = @"/items/related?";
NSString * const API_PHOTO_CAT  = @"/photo_cat?";
NSString * const API_PHOTO  = @"/photo?";
NSString * const API_NEWS  = @"/news?";
NSString * const API_NEWS_DETAIL  = @"/news/detail?";
NSString * const API_RESERVE = @"/reserve?";
NSString * const API_COUPON  = @"/coupon?";
NSString * const API_COUPON_DETAIL = @"/coupon/detail?";
NSString * const API_APPUSER  = @"/appuser?";
NSString * const API_SETPUSHKEY = @"/setpushkey?";

#pragma mark - API_KEY

NSString * const KeyAPI_APP_ID = @"app_id";
NSString * const KeyAPI_TIME = @"time";
NSString * const KeyAPI_SIG = @"sig";
NSString * const KeyAPI_STORE_ID = @"store_id";

/// Login| Logout
NSString * const KeyAPI_EMAIL = @"email";
NSString * const KeyAPI_PASSWORD = @"password";
NSString * const KeyAPI_TOKEN = @"token";

/// Social
NSString * const KeyAPI_SOCIAL_TYPE = @"social_type";
NSString * const KeyAPI_SOCIAL_ID = @"social_id";
NSString * const KeyAPI_SOCIAL_TOKEN = @"social_token";
NSString * const KeyAPI_SOCIAL_SECRET = @"social_secret";

///Data Common
NSString * const KeyAPI_PAGE_INDEX = @"pageindex";
NSString * const KeyAPI_PAGE_SIZE = @"pagesize";

///Menu
NSString * const KeyAPI_MENU_ID = @"menu_id";
NSString * const KeyAPI_ITEM_ID = @"item_id";

///Photo
NSString * const KeyAPI_CATEGORY_ID = @"category_id";

///Coupon
NSString * const KeyAPI_COUPON_ID = @"coupon_id";

///Profile
NSString * const KeyAPI_USERNAME = @"username";
NSString * const KeyAPI_GENDER = @"gender";
NSString * const KeyAPI_ADDRESS = @"address";
NSString * const KeyAPI_AVATAR = @"avatar";

///Push
NSString * const KeyAPI_CLIENT = @"client";
NSString * const KeyAPI_KEY = @"key";
NSString * const KeyAPI_RANKING = @"ranking";
NSString * const KeyAPI_NEWS = @"news";
NSString * const KeyAPI_COUPON = @"coupon";
NSString * const KeyAPI_CHAT = @"chat";



#pragma mark - Static methods

+ (NSString *)getImageRequestURL:(NSString *)imageURL{
    return [NSString stringWithFormat:@"%@%@",BASE_ADDRESS,imageURL];
}

+ (NSString *)APIAddress{
    return [NSString stringWithFormat:@"%@%@",BASE_ADDRESS,API_BASE];
}

+(NSString*) requestBuilder:(Bundle *)params{
    
    NSString* strUrlParams = @"";
    
    NSMutableArray* arrayParams = [[NSMutableArray alloc] initWithObjects:
                                   KeyAPI_APP_ID,
                                   KeyAPI_TIME,
                                   KeyAPI_SIG,
                                   KeyAPI_STORE_ID,
                                   KeyAPI_EMAIL,
                                   KeyAPI_PASSWORD,
                                   KeyAPI_SOCIAL_TYPE,
                                   KeyAPI_SOCIAL_ID,
                                   KeyAPI_SOCIAL_TOKEN,
                                   KeyAPI_SOCIAL_SECRET,
                                   KeyAPI_TOKEN,
                                   KeyAPI_PAGE_INDEX,
                                   KeyAPI_PAGE_SIZE,
                                   KeyAPI_MENU_ID,
                                   KeyAPI_ITEM_ID,
                                   KeyAPI_CATEGORY_ID,
                                   KeyAPI_COUPON_ID,
                                   KeyAPI_USERNAME,
                                   KeyAPI_GENDER,
                                   KeyAPI_ADDRESS,
                                   KeyAPI_AVATAR,
                                   KeyAPI_CLIENT,
                                   KeyAPI_KEY,
                                   KeyAPI_RANKING,
                                   KeyAPI_NEWS,
                                   KeyAPI_COUPON,
                                   KeyAPI_CHAT,
                                   nil];
    
    for (NSString* param in arrayParams) {
        NSString* value = [params get:param];
        if(value != nil){
            strUrlParams = [strUrlParams stringByAppendingFormat:@"%@=%@&", param, [value stringByUrlEncoding]];
        }
    }
    if([strUrlParams length] > 0 && [[strUrlParams substringFromIndex:[strUrlParams length] -1] isEqualToString:@"&"]){
        strUrlParams = [strUrlParams substringToIndex:[strUrlParams length] - 1];
    }
    
    return strUrlParams;
}
@end
