//
//  UserData.m
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/27/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import "UserData.h"
@interface UserData()

@property (strong, nonatomic) NSString * token;
@property (strong, nonatomic) NSString * refreshToken;
@property (strong, nonatomic) NSString * href_refreshToken;

@end

@implementation UserData

+(UserData *)shareInstance{
    static UserData *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[UserData alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - save and load user data

- (void)invalidateCurrentUser{
    [self clearUserData];
    [self clearTokenData];
    _isLogin = NO;
}

-(void)clearUserData {
    [_userDataDictionary removeAllObjects];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:nil forKey:@"userData"];
    [userDef synchronize];
}

-(BOOL)saveUserData{
    NSError *error;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSData *data =  [NSJSONSerialization dataWithJSONObject:_userDataDictionary options:0 error:&error];
    if (!data) {
        return  NO;
    }
    if (!error) {
        [userDef setObject:data forKey:@"userData"];
        [userDef synchronize];
        _isLogin = YES;
        return YES;
    }
    return NO;
}

-(NSDictionary *)getUserData{
    NSError *error;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDef objectForKey:@"userData"];
    if (!data) {
        return nil;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!error) {
        _userDataDictionary = [dic mutableCopy];
        _isLogin = YES;
        return dic;
    }
    return nil;
}

#pragma mark - Token

- (void)setToken:(NSString *)token{
    _token = token;
}

- (void)setRefreshToken:(NSString *)refreshToken{
    _refreshToken = refreshToken;
}

- (void)setHref_refreshToken:(NSString *)href_refreshToken{
    _href_refreshToken = href_refreshToken;
}

- (BOOL)saveTokenKit:(NSDictionary *)tokenKit{
    if ([tokenKit objectForKey:@"token"]) {
        [self setToken:[tokenKit objectForKey:@"token"]];
    }else{
        return NO;
    }
    
    if([tokenKit objectForKey:@"refresh_token"]) {
        [self setRefreshToken:[tokenKit objectForKey:@"refresh_token"]];
    }else{
        return NO;
    }
    
    if ([tokenKit objectForKey:@"access_refresh_token_href"]) {
        [self setHref_refreshToken:[tokenKit objectForKey:@"access_refresh_token_href"]];
    }
    
    NSError *error;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSData *data =  [NSJSONSerialization dataWithJSONObject:tokenKit options:0 error:&error];
    if (!data) {
        return  NO;
    }
    if (!error) {
        [userDef setObject:data forKey:@"userToken"];
        [userDef synchronize];
        return YES;
    }else
        return NO;
    
    return YES;
}

- (void)clearTokenData{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:nil forKey:@"userToken"];
    [userDef synchronize];
    _token = nil;
    _refreshToken = nil;
    _href_refreshToken = nil;
}

- (BOOL)loadSavedToken{
    NSError *error;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDef objectForKey:@"userToken"];
    if (!data) {
        return NO;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    [self setToken:[dic objectForKey:@"token"]];
    [self setRefreshToken:[dic objectForKey:@"refresh_token"]];
    [self setHref_refreshToken:[dic objectForKey:@"access_refresh_token_href"]];
    return YES;
}

-(NSString *)getToken{
    if (!_token || [_token isEqualToString:@""]) {
        [self loadSavedToken];
    }
    return _token; //[[self getUserData] objectForKey:@"token"];
}

-(NSString *)getRefreshToken{
    if (!_refreshToken || [_refreshToken isEqualToString:@""]) {
        [self loadSavedToken];
    }
    return _refreshToken; //[[self getUserData] objectForKey:@"token"];
}

- (NSString *)getHrefRefreshToken{
    if (!_href_refreshToken || [_href_refreshToken isEqualToString:@""]) {
        [self loadSavedToken];
    }
    return _href_refreshToken;
}


@end
