//
//  PushNotificationManager.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 12/5/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "PushNotificationManager.h"
#import "Utils.h"
#import "Const.h"

NSString * const PUSH_BASE_ADDRESS = @"https://apinotification.ten-po.com";

NSString * const PUSH_USER_SETPUSHKEY = @"/v1/user/set_push_key";
NSString * const PUSH_STAFF_SETPUSHKEY = @"/v1/staff/set_push_key";

NSString * const PUSH_CONFIGURE_NOTIFICATION = @"/v1/configure_notification";

NSString * const PUSH_USER_NOTIFICATION = @"/v1/user/notification";
NSString * const PUSH_STAFF_NOTIFICATION = @"/v1/staff/notification";

NSString * const PUSH_USER_SETPUSHSETTINGS = @"/v1/user/set_push_setting";
NSString * const PUSH_USER_GETPUSHSETTINGS = @"/v1/user/get_push_setting";

@implementation PushNotificationManager

+(PushNotificationManager *)sharedInstance{
    
    static PushNotificationManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[PushNotificationManager alloc] init];
    });
    return _sharedInstance;
}

- (void)PushUserSetPushKey:(NSString *)key WithCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock{
    _request_url = [NSString stringWithFormat:@"%@%@",PUSH_BASE_ADDRESS,PUSH_USER_SETPUSHKEY];
    
    Bundle *body = [Bundle new];
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    [dictData setObject:APP_ID forKey:KeyAPI_APP_ID];
    [dictData setObject:key forKey:KeyAPI_KEY];
    [dictData setObject:@"ios" forKey:KeyAPI_CLIENT];
    
    NSString *strData = [Utils makeParamtersString:dictData withEncoding:NSUTF8StringEncoding];
    NSData *req_data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    [body put:KeyRequestData value:req_data];
    [body put:KeyRequestCallback value:completeBlock];
    
    [self execute:body withDelegate:self andAuthHeaderType:AuthenticationType_authorization];
}

- (void)PushGetUserPushSettingsWithCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock{
    _request_url = [NSString stringWithFormat:@"%@%@?%@=%@",PUSH_BASE_ADDRESS,PUSH_USER_GETPUSHSETTINGS,KeyAPI_APP_ID,APP_ID];

    Bundle *body = [Bundle new];
    
    [body put:KeyRequestCallback value:completeBlock];
    
    [self execute:body withDelegate:self andAuthHeaderType:AuthenticationType_authorization];
}

- (void)PushSetUserPushSettings:(NSMutableDictionary *)pushData WithCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock{
    
    _request_url = [NSString stringWithFormat:@"%@%@",PUSH_BASE_ADDRESS,PUSH_USER_SETPUSHSETTINGS];
    
    Bundle *body = [Bundle new];
    NSMutableDictionary *dictData = [pushData mutableCopy];
    [dictData setObject:APP_ID forKey:KeyAPI_APP_ID];
    
    NSString *strData = [Utils makeParamtersString:dictData withEncoding:NSUTF8StringEncoding];
    NSData *req_data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    [body put:KeyRequestData value:req_data];
    [body put:KeyRequestCallback value:completeBlock];
    
    [self execute:body withDelegate:self andAuthHeaderType:AuthenticationType_authorization];
}

- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
    NSError *error = nil;
    if (errorCode != ERROR_OK) {
        NSString *errorDomain = [CommunicatorConst getErrorMessage:errorCode];
        NSLog(@"request error: %@", errorDomain);
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
        void (^callback)(BOOL isSuccess,NSDictionary *dictionary) =[responseParams get:KeyRequestCallback];
        if (callback)
            callback(false,[responseParams get:KeyResponseObject]);
    }else{
        void (^callback)(BOOL isSuccess,NSDictionary *dictionary) =[responseParams get:KeyRequestCallback];
        if (callback)
            callback(true,[responseParams get:KeyResponseObject]);
    }
}

- (void)customPrepare:(Bundle *)params{
    _request_url = [_request_url stringByAppendingFormat:@"%@", [RequestBuilder requestBuilder:params]];
    [params put:KeyRequestURL value:_request_url];
}

- (void)customProcess:(Bundle *)params{
    
    NSError* error = nil;
    
    CommonResponse* data = nil;
    
    @try {
        data = [[CommonResponse alloc] initWithData:self.responseData error:&error];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        
    }
    
    NSLog(@"ERROR MESSAGE : %@", data.message);
    
    if( error != nil){
        NSLog(@"%@", error);
        //TODO: real error code
        [params put:KeyResponseResult value:@(9000)];
    }else{
        if(data.code != ERROR_OK){
            NSString* description = [CommunicatorConst getErrorMessage:data.code];
            [params put:KeyResponseResult value:@(data.code)];
            [m_pParams put:KeyResponseError value:description];
            NSLog(@"%@ - err: %ld", [params get:KeyRequestURL], (long)data.code);
        }else{
            [params put:KeyResponseResult value:@(data.code)];
            [params put:KeyResponseObject value:data];
        }
    }
}

@end
