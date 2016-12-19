//
//  UserData.m
//  Moki
//
//  Created by MQ Solutions on 2/3/15.
//  Copyright (c) 2015 MQ Solutions. All rights reserved.
//

#import "UserData.h"
#import "Const.h"
#import "UIUtils.h"
#import "SettingsEditProfileScreen.h"
#import "Utils.h"
#import "AuthenticationManager.h"
#import "PushNotificationManager.h"

@interface UserData()

@property (strong, nonatomic) NSString * token;
@property (strong, nonatomic) NSString * refreshToken;
@property (strong, nonatomic) NSString * href_refreshToken;

@end

@implementation UserData

NSMutableArray *recentSearchList=nil;

+(UserData *)shareInstance{
    static UserData *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[UserData alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - save and load user data

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

- (void)invalidateCurrentUser{
    [self clearUserData];
    [self clearTokenData];
    _isLogin = NO;
    [self setUserAvatarImg:nil];
}

-(void)clearUserData {
    [_userDataDictionary removeAllObjects];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:nil forKey:@"userData"];
    [userDef synchronize];
}

- (void)clearTokenData{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:nil forKey:@"userToken"];
    [userDef synchronize];
    _token = nil;
    _refreshToken = nil;
    _href_refreshToken = nil;
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

- (BOOL)updateNewProfile:(NSDictionary *)newProfile{
    NSDictionary * toUpdate = nil;
    if ([newProfile objectForKey:@"user"]) {
        toUpdate = [[newProfile objectForKey:@"user"] copy];
    }else{
        toUpdate = [newProfile copy];
    }
    [self setUserEmail:[toUpdate objectForKey:@"email"]];
    if ([toUpdate objectForKey:@"profile"]) {
        NSDictionary *profile = [toUpdate objectForKey:@"profile"];
        [self setUserName:[profile objectForKey:@"name"]];
        [self setUserProvine:[profile objectForKey:@"address"]];
        NSString *gen = [profile objectForKey:@"gender"];
        if (gen && ![gen isEqualToString:@""]) {
            [self setUserGender:[gen integerValue]];
        }
        [self setUserAvatarUrl:[profile objectForKey:@"avatar_url"]];
        [self setFacebookStatus:[profile objectForKey:@"facebook_status"]];
        [self setTwitterStatus:[profile objectForKey:@"twitter_status"]];
        [self setInstagramStatus:[profile objectForKey:@"instagram_status"]];
    }
    
    [self saveUserData];
    
    return YES;
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

-(NSString *)getUserID{
    if (_userDataDictionary) {
        return [[_userDataDictionary objectForKey:@"id"] stringValue];
    }
    return [[self getUserData] objectForKey:@"id"];
}

-(NSString *) getAuthUserID{
    NSObject *auth;
    if (_userDataDictionary) {
        auth =  [_userDataDictionary objectForKey:@"auth_user_id"];
    }else{
        auth = [[self getUserData] objectForKey:@"auth_user_id"];
    }
    if ([auth isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)auth stringValue];
    }else{
        return (NSString *)auth;
    }
}

-(NSString *)getUserName{
    if (_userDataDictionary) {
        return [[_userDataDictionary objectForKey:@"profile"] objectForKey:@"name"];
    }
    return [[[self getUserData] objectForKey:@"profile"] objectForKey:@"name"];
}
-(void)setUserName:(NSString *)username{
    if (!username) {
        return;
    }
    if (!_userDataDictionary) {
        [self getUserData];
    }
    NSMutableDictionary *profile = [[_userDataDictionary objectForKey:@"profile"] mutableCopy];
    [profile setObject:username forKey:@"name"];
    [_userDataDictionary setObject:profile forKey:@"profile"] ;
    [self saveUserData];
}

-(void)setUserEmail:(NSString *)email{
    if (!email) {
        return;
    }
    if (!_userDataDictionary) {
        [self getUserData];
    }
    [_userDataDictionary setObject:email forKey:@"email"];
    [self saveUserData];
}

-(NSString *)getUserEmail{
    NSString *email;
    if (_userDataDictionary) {
        email = [_userDataDictionary objectForKey:@"email"];
    }else{
        email = [[self getUserData] objectForKey:@"email"];
    }
    
    if(!email || [email isKindOfClass:[NSNull class]]){
        return @"";
    }else{
        return email;
    }
}

- (void)setUserGender:(NSInteger) gender{
    if (!_userDataDictionary) {
        [self getUserData];
    }
    NSMutableDictionary *profile = [[_userDataDictionary objectForKey:@"profile"] mutableCopy];
    [profile setObject:[@(gender) stringValue] forKey:@"gender"];
    [_userDataDictionary setObject:profile forKey:@"profile"] ;
    [self saveUserData];
}

- (NSInteger)getUserGender{
    if (_userDataDictionary) {
        return [[[_userDataDictionary objectForKey:@"profile"] objectForKey:@"gender"] integerValue];
    }
    return [[[[self getUserData] objectForKey:@"profile"] objectForKey:@"gender"] integerValue];
}

- (NSString *)getUserGenderString{
    if (_userDataDictionary) {
        NSString *gender = (NSString *)[[_userDataDictionary objectForKey:@"profile"] objectForKey:@"gender"];
        if ([gender isEqualToString:@"0"]) {
            //TODO: need localize
            return NSLocalizedString(@"gender_male",nil);
        }else if ([gender isEqualToString:@"1"]) {
            return NSLocalizedString(@"gender_female",nil);
        }
    }
    NSString *gender = (NSString *)[[[self getUserData] objectForKey:@"profile"] objectForKey:@"gender"];
    NSInteger genderInt = [gender integerValue];
    if (genderInt == GENDER_MALE) {
        //TODO: need localize
        return NSLocalizedString(@"gender_male",nil);
    }else if (genderInt == GENDER_MALE) {
        return NSLocalizedString(@"gender_female",nil);
    }
    return @"";
}

- (void)setUserAvatarUrl:(NSString *)url{
    if (!url) {
        return;
    }
    NSMutableDictionary *profile = [[_userDataDictionary objectForKey:@"profile"] mutableCopy];
    [profile setObject:url forKey:@"avatar_url"];
    [_userDataDictionary setObject:profile forKey:@"profile"] ;
    [self saveUserData];
}

-(NSString *)getUserAvatarUrl{
    NSString *avatarUrl;
    if (_userDataDictionary) {
        avatarUrl = [[_userDataDictionary objectForKey:@"profile"] objectForKey:@"avatar_url"];
    }else{
        avatarUrl = [[[self getUserData] objectForKey:@"profile"] objectForKey:@"avatar_url"];
    }
    if (!avatarUrl || [avatarUrl isKindOfClass:[NSNull class]]) {
        return nil;
    }
    if (![avatarUrl hasPrefix:@"http"]) {
        avatarUrl = [NSString stringWithFormat:@"https://api.ten-po.com/%@",avatarUrl];
    }
    return avatarUrl;
}

-(void)setUserAvatarImg:(UIImage*)avatar{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    if (!avatar) {
        [userDefaults setObject:[[NSData alloc]init] forKey:@"avatar_image"];
        return;
    }
    NSData * data=UIImagePNGRepresentation(avatar);
    [userDefaults setObject:data forKey:@"avatar_image"];
    [userDefaults synchronize];
}
-(UIImage*)getUserAvatarImg{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [UIImage imageWithData:[userDefaults objectForKey:@"avatar_image"]];
}

-(BOOL)setDevToken:(NSString *)devToken{
    if (!devToken) {
        return NO;
    }
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    [userdef setObject:devToken forKey:@"deviceToken"];
    [userdef synchronize];
    return YES;
}
-(NSString *)getDevToken{
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSString *temp  = [userdef stringForKey:@"deviceToken"];
    return temp;
}

- (NSString *)getAppUserID{
    if (_userDataDictionary) {
        return [_userDataDictionary objectForKey:@"id"];
        //return [[_userDataDictionary objectForKey:@"profile"] objectForKey:@"id"];
    }
    return [[self getUserData] objectForKey:@"id"];
}

- (void)setAppUserID:(NSString *)app_user_id{
    if (!app_user_id) {
        return;
    }
    if (!_userDataDictionary) {
        [self getUserData];
    }
    NSMutableDictionary *profile = [[_userDataDictionary objectForKey:@"profile"] mutableCopy];
    [profile setObject:app_user_id forKey:@"app_user_id"];
    [_userDataDictionary setObject:profile forKey:@"profile"] ;
    [self saveUserData];
}

- (void)setUserProvine:(NSString *)provine{
    if(!provine){
        return;
    }
    if (!_userDataDictionary) {
        [self getUserData];
    }
    NSMutableDictionary *profile = [[_userDataDictionary objectForKey:@"profile"] mutableCopy];
    [profile setObject:provine forKey:@"address"];
    [_userDataDictionary setObject:profile forKey:@"profile"] ;
    [self saveUserData];
}

- (NSString *)getUserProvine{
    NSString *province;
    if (_userDataDictionary) {
        province = [[_userDataDictionary objectForKey:@"profile"] objectForKey:@"address"];
    }else{
        province = [[[self getUserData] objectForKey:@"profile"] objectForKey:@"address"];
    }
    if (!province || [province isKindOfClass:[NSNull class]]) {
        return @"";
    }else{
        return province;
    }
}

- (void)setFacebookStatus:(NSString *)status{
    if(!status){
        return;
    }
    if (!_userDataDictionary) {
        [self getUserData];
    }
    NSMutableDictionary *profile = [[_userDataDictionary objectForKey:@"profile"] mutableCopy];
    [profile setObject:status forKey:@"facebook_status"];
    [_userDataDictionary setObject:profile forKey:@"profile"] ;
    [self saveUserData];
}

- (NSString *)getFacebookStatus{
    NSObject *status;
    if (_userDataDictionary) {
        status = [[_userDataDictionary objectForKey:@"profile"] objectForKey:@"facebook_status"];
    }else{
        status = [[[self getUserData] objectForKey:@"profile"] objectForKey:@"facebook_status"];
    }
    if ([status isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)status stringValue];
    }else{
        return (NSString *)status;
    }
}

- (void)setTwitterStatus:(NSString *)status{
    if(!status){
        return;
    }
    if (!_userDataDictionary) {
        [self getUserData];
    }
    NSMutableDictionary *profile = [[_userDataDictionary objectForKey:@"profile"] mutableCopy];
    [profile setObject:status forKey:@"twitter_status"];
    [_userDataDictionary setObject:profile forKey:@"profile"] ;
    [self saveUserData];
}

- (NSString *)getTwitterStatus{
    NSObject *status;
    if (_userDataDictionary) {
        status = [[_userDataDictionary objectForKey:@"profile"] objectForKey:@"twitter_status"];
    }else{
        status = [[[self getUserData] objectForKey:@"profile"] objectForKey:@"twitter_status"];
    }
    if ([status isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)status stringValue];
    }else{
        return (NSString *)status;
    }
}

- (void)setInstagramStatus:(NSString *)status{
    if(!status){
        return;
    }
    if (!_userDataDictionary) {
        [self getUserData];
    }
    NSMutableDictionary *profile = [[_userDataDictionary objectForKey:@"profile"] mutableCopy];
    [profile setObject:status forKey:@"instagram_status"];
    [_userDataDictionary setObject:profile forKey:@"profile"] ;
    [self saveUserData];
}

- (NSString *)getInstagramStatus{
    NSObject *status;
    if (_userDataDictionary) {
        status = [[_userDataDictionary objectForKey:@"profile"] objectForKey:@"instagram_status"];
    }else{
        status = [[[self getUserData] objectForKey:@"profile"] objectForKey:@"instagram_status"];
    }
    if ([status isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)status stringValue];
    }else{
        return (NSString *)status;
    }
}

- (void)updateProfile:(NSMutableDictionary *)profileToUpdate{
    if(![self getToken] || [profileToUpdate count] == 0){
        return;
    }
    
    //Build user data to update
    
    if (![profileToUpdate objectForKey:KeyAPI_APP_ID]) {
        [profileToUpdate setObject:APP_ID forKey:KeyAPI_APP_ID];
    }
    
    if (![profileToUpdate objectForKey:KeyAPI_USERNAME_NAME]) {
        if ([self getUserName]) {
            [profileToUpdate setObject:[self getUserName] forKey:KeyAPI_USERNAME_NAME];
        }else{
            [profileToUpdate setObject:@"" forKey:KeyAPI_USERNAME_NAME];
        }
    }
    
    if (![profileToUpdate objectForKey:KeyAPI_GENDER]) {
        if ([self getUserGender]) {
            [profileToUpdate setObject:[@([self getUserGender]) stringValue] forKey:KeyAPI_GENDER];
        }else{
            [profileToUpdate setObject:@"1" forKey:KeyAPI_GENDER];
        }
    }
    
    if(![profileToUpdate objectForKey:KeyAPI_ADDRESS]){
        if ([self getUserProvine]) {
            [profileToUpdate setObject:[self getUserProvine] forKey:KeyAPI_ADDRESS];
        }else{
            [profileToUpdate setObject:@"abc" forKey:KeyAPI_ADDRESS];
        }
    }
    
    if(![profileToUpdate objectForKey:KeyAPI_AVATAR]){
        //        [profileToUpdate setObject:[[NSData alloc]init] forKey:KeyAPI_AVATAR];
    }else{
        UIImage *image = (UIImage *)[profileToUpdate objectForKey:KeyAPI_AVATAR];
        image = [UIUtils scaleImage:image toSize:CGSizeMake(200,200)];
        NSData *imageData = UIImagePNGRepresentation(image);
        [profileToUpdate setObject:imageData forKey:KeyAPI_AVATAR];
    }
    
    [[NetworkCommunicator shareInstance] POSTWithImage:API_UPDATE_PROFILE parameters:profileToUpdate onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
        NSLog(@"UPDATE_PROFILE");
        [profileToUpdate removeAllObjects];
        if (isSuccess) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_USER_PROFILE_REQUEST object:nil userInfo:@{@"status":@"success"}];
            
            if (![self getToken]) {
                return;
            }else{
                //Update profile from server
                [[AuthenticationManager sharedInstance] AuthGetUserProfileWithCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
                    NSMutableDictionary *resultDict;
                    if([resultData isKindOfClass:[CommonResponse class]]){
                        CommonResponse *result = (CommonResponse *)resultData;
                        resultDict = result.data;
                    }else{
                        resultDict = [resultData mutableCopy];
                    }
                    if (isSuccess) {
                        NSMutableDictionary *userData = [resultDict objectForKey:@"user"];
                        [UserData shareInstance].userDataDictionary = [userData mutableCopy];
                        [[UserData shareInstance] saveUserData];
                        [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_USER_PROFILE_UPDATED object:nil userInfo:@{@"status":@"success"}];
                    }else{
                        [self setUserAvatarImg:nil];
                    }
                }];
            }
        }else{
            NSLog(@"%@", dictionary);
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_USER_PROFILE_REQUEST object:nil userInfo:@{@"status":@"failed"}];
        }
    }];
    
}

- (void)updatePushSetting:(NSMutableDictionary *)infoToUpdate{
    if(![self getToken] || [infoToUpdate count] == 0){
        return;
    }
    if ([self getToken]) {
        [[PushNotificationManager sharedInstance] PushSetUserPushSettings:infoToUpdate WithCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
            if(isSuccess){
                NSLog(@"Update push settings SUCCESS!");
            }else{
                NSLog(@"Update push settings FAILD!");
            }
        }];
    }
}

- (void)updateSocialSetting:(NSMutableDictionary *)infoToUpdate{
    
    if(![self getToken] || [infoToUpdate count] == 0){
        return;
    }
    
    __weak NSNumber *socialType = [infoToUpdate objectForKey:KeyAPI_SOCIAL_TYPE];
    [[AuthenticationManager sharedInstance] AuthLinkSocialProfile:infoToUpdate WithCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData){
        if(isSuccess){
            if ([socialType integerValue] == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SET_EDIT_FACEBOOK:@"1"}];
            }else if ([socialType integerValue] == 2){
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SET_EDIT_TWITTER:@"1"}];
            }else if ([socialType integerValue] == 3){
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SET_EDIT_INSTAGRAM:@"1"}];
            }
            
        }else{
            if ([socialType integerValue] == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SET_EDIT_FACEBOOK:@"0"}];
            }else if ([socialType integerValue] == 2){
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SET_EDIT_TWITTER:@"0"}];
            }else if ([socialType integerValue] == 3){
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SET_EDIT_INSTAGRAM:@"0"}];
            }
        }
    }];
}

- (void)cancelSocial:(NSString *)type{
    if(![self getToken] || !type){
        return;
    }
    [[AuthenticationManager sharedInstance] AuthCancelLinkSocialProfileType:[type integerValue] WithCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
        if(isSuccess){
            if ([type integerValue] == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SET_EDIT_FACEBOOK:@"0"}];
            }else if ([type integerValue] == 2){
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SET_EDIT_TWITTER:@"0"}];
            }else if ([type integerValue] == 3){
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SET_EDIT_INSTAGRAM:@"0"}];
            }
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_USER_PROFILE_REQUEST object:nil userInfo:@{@"status":@"failed"}];
        }
    }];
}


@end
