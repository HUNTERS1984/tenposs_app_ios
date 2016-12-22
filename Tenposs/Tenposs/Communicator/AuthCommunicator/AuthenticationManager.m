//
//  AuthenticationManager.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/22/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "AuthenticationManager.h"
#import "Utils.h"
#import "Const.h"
#import "RequestBuilder.h"
#import "UserData.h"

NSString * const AUTH_BASE_ADDRESS  =  @"https://auth.ten-po.com";

NSString * const AUTH_LOGIN = @"/v1/auth/login";
NSString * const AUTH_ACCESS_TOKEN  = @"/v1/auth/access_token";
NSString * const AUTH_PROFILE  = @"/v1/profile";
NSString * const AUTH_CHANGE_PASSWORD  = @"/v1/auth/changepassword";
NSString * const AUTH_CHECK_USER_EXIST  = @"/v1/auth/check_user_exist";
NSString * const AUTH_SOCIAL_LOGIN  = @"/v1/auth/social_login";
NSString * const AUTH_SIGNOUT  = @"/v1/auth/signout";
NSString * const AUTH_REGISTER = @"/v1/auth/register";

NSString * const KeyAPI_ROLE = @"role";
NSString * const ROLE_USER = @"user";
NSString * const ROLE_ADMIN = @"admin";
NSString * const ROLE_CLIENT = @"client";
NSString * const ROLE_STAFF = @"staff";

NSString * const KeyAPI_PLATFORM = @"platform";
NSString * const PLATFORM_IOS = @"ios";

@implementation AuthenticationManager

+(AuthenticationManager *)sharedInstance{
    
    static AuthenticationManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[AuthenticationManager alloc] init];
    });
    return _sharedInstance;
}

- (void)AuthSignUpWithEmail:(NSMutableDictionary *)data andCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock{
    _request_url = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddressV2],API_SIGNUP];
    
    NSMutableDictionary *signUpData = [data mutableCopy];
    [signUpData setObject:APP_ID forKey:KeyAPI_APP_ID];
    NSString *strData = [Utils makeParamtersString:signUpData withEncoding:NSUTF8StringEncoding];
    NSData *req_data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    Bundle *body = [Bundle new];
    [body put:KeyRequestData value:req_data];
    [body put:KeyRequestCallback value:completeBlock];
    
    [self execute:body withDelegate:self];
}

- (void)AuthSignUpWithSocialAccount:(NSMutableDictionary *)data andCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock{
    _request_url = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddressV2],API_SIGNUP_SOCIAL];
    
    NSMutableDictionary *signUpData = [data mutableCopy];
    [signUpData setObject:APP_ID forKey:KeyAPI_APP_ID];
    NSString *strData = [Utils makeParamtersString:signUpData withEncoding:NSUTF8StringEncoding];
    NSData *req_data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    Bundle *body = [Bundle new];
    [body put:KeyRequestData value:req_data];
    [body put:KeyRequestCallback value:completeBlock];
    
    [self execute:body withDelegate:self];
}

- (void)AuthUpdateProfileAfterSocialSignUp:(NSMutableDictionary *)data andCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock{
    _request_url = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddressV2],API_UPDATE_AFTER_SOCIAL];
    NSMutableDictionary *signUpData = [data mutableCopy];
    [signUpData setObject:APP_ID forKey:KeyAPI_APP_ID];
    NSString *strData = [Utils makeParamtersString:signUpData withEncoding:NSUTF8StringEncoding];
    NSData *req_data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    Bundle *body = [Bundle new];
    [body put:KeyRequestData value:req_data];
    [body put:KeyRequestCallback value:completeBlock];
    
    [self execute:body withDelegate:self andAuthHeaderType:AuthenticationType_authorization];
}

- (void)AuthLoginWithEmail:(NSString *)email password:(NSString *)password role:(NSString *)role andCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock{
    
    _request_url = [NSString stringWithFormat:@"%@%@",AUTH_BASE_ADDRESS,AUTH_LOGIN];
    
    Bundle *body = [Bundle new];
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    [dictData setObject:email forKey:KeyAPI_EMAIL];
    [dictData setObject:password forKey:KeyAPI_PASSWORD];
    [dictData setObject:role forKey:KeyAPI_ROLE];
    [dictData setObject:PLATFORM_IOS forKey:KeyAPI_PLATFORM];
    
    NSString *strData = [Utils makeParamtersString:dictData withEncoding:NSUTF8StringEncoding];
    NSData *req_data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    [body put:KeyRequestData value:req_data];
    [body put:KeyRequestCallback value:completeBlock];
    
    [self execute:body withDelegate:self andAuthHeaderType:AuthenticationType_basicAuth];
}

- (void)AuthLogOutWithCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock{
    _request_url = [NSString stringWithFormat:@"%@%@",AUTH_BASE_ADDRESS,AUTH_SIGNOUT];
    Bundle *body = [Bundle new];
    [body put:KeyRequestData value:[[NSData alloc] init]];
    [body put:KeyRequestCallback value:completeBlock];
    
    [self execute:body withDelegate:self andAuthHeaderType:AuthenticationType_authorization];
}

- (void)AuthGetUserProfileWithCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock{
    _request_url = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddressV2],API_PROFILE];
    Bundle *body = [Bundle new];
    [body put:KeyAPI_APP_ID value:APP_ID];
    [body put:KeyRequestCallback value:completeBlock];
    [self execute:body withDelegate:self andAuthHeaderType:AuthenticationType_authorization];
}

- (void)AuthRefreshTokenWithCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock{
    NSString *refreshHref = [[UserData shareInstance] getHrefRefreshToken];
    if (refreshHref && ![refreshHref isEqualToString:@""]) {
        _request_url = refreshHref;
    }
    
    Bundle *body = [Bundle new];
    [body put:KeyRequestCallback value:completeBlock];
    [self execute:body withDelegate:self andAuthHeaderType:AuthenticationType_basicAuth];
}

- (void)AuthLinkSocialProfile:(NSMutableDictionary *)socialData WithCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock{
    _request_url = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddressV2],API_SOCIALSETTING];
    NSMutableDictionary *data = [socialData mutableCopy];
    [data setObject:APP_ID forKey:KeyAPI_APP_ID];
    NSString *strData = [Utils makeParamtersString:data withEncoding:NSUTF8StringEncoding];
    NSData *req_data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    Bundle *body = [Bundle new];
    [body put:KeyRequestData value:req_data];
    [body put:KeyRequestCallback value:completeBlock];
    
    [self execute:body withDelegate:self andAuthHeaderType:AuthenticationType_authorization];
}

- (void)AuthCancelLinkSocialProfileType:(NSInteger)socialType WithCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock{
    _request_url = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddressV2],API_SOCIAL_CANCEL];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:APP_ID forKey:KeyAPI_APP_ID];
    [data setObject:@(socialType) forKey:KeyAPI_SOCIAL_TYPE];
    NSString *strData = [Utils makeParamtersString:data withEncoding:NSUTF8StringEncoding];
    NSData *req_data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    Bundle *body = [Bundle new];
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
            [params put:KeyResponseObject value:data];
            NSLog(@"%@ - err: %ld", [params get:KeyRequestURL], (long)data.code);
        }else{
            [params put:KeyResponseResult value:@(data.code)];
            [params put:KeyResponseObject value:data];
        }
    }
}

@end
