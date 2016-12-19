//
//  AuthenticationManager.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/22/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TenpossCommunicator.h"
#import "NetworkCommunicator.h"

extern NSString * const AUTH_BASE_ADDRESS;

extern NSString * const AUTH_LOGIN;
extern NSString * const AUTH_ACCESS_TOKEN;
extern NSString * const AUTH_PROFILE;
extern NSString * const AUTH_CHANGE_PASSWORD;
extern NSString * const AUTH_CHECK_USER_EXIST;
extern NSString * const AUTH_SOCIAL_LOGIN;
extern NSString * const AUTH_SIGNOUT;
extern NSString * const AUTH_REGISTER;

extern NSString * const KeyAPI_ROLE;
extern NSString * const ROLE_USER;
extern NSString * const ROLE_ADMIN;
extern NSString * const ROLE_CLIENT;
extern NSString * const ROLE_STAFF;

extern NSString * const KeyAPI_PLATFORM;
extern NSString * const PLATFORM_IOS;


@interface AuthenticationManager : TenpossCommunicator <TenpossCommunicatorDelegate>

@property (strong, nonatomic) NSString *request_url;

+(AuthenticationManager *) sharedInstance;

- (void)AuthLoginWithEmail:(NSString *)email password:(NSString *)password role:(NSString *)role andCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock;

- (void)AuthGetUserProfileWithCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock;

//- (void)AuthSignUpWithEmail:(NSMutableDictionary *)data andCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock;

//- (void)AuthSignUpWithSocialAccount:(NSMutableDictionary *)data andCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock;
//
//- (void)AuthUpdateProfileAfterSocialSignUp:(NSMutableDictionary *)data andCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock;

- (void)AuthRefreshTokenWithCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock;

- (void)AuthLogOutWithCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock;

//- (void)AuthLinkSocialProfile:(NSMutableDictionary *)socialData WithCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock;
//
//- (void)AuthCancelLinkSocialProfileType:(NSInteger)socialType WithCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock;

@end
