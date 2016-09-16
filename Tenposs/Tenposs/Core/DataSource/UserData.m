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
-(void)clearUserData {
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
-(NSString *)getToken{
    if (_userDataDictionary) {
        return [_userDataDictionary objectForKey:@"token"];
    }
    return [[self getUserData] objectForKey:@"token"];
}
-(NSString *)getUserID{
    if (_userDataDictionary) {
        return [_userDataDictionary objectForKey:@"id"];
    }
    return [[self getUserData] objectForKey:@"id"];
}
-(NSString *)getUserName{
    if (_userDataDictionary) {
        return [[_userDataDictionary objectForKey:@"profile"] objectForKey:@"name"];
    }
    return [[[self getUserData] objectForKey:@"profile"] objectForKey:@"name"];
}
-(void)setUserName:(NSString *)username{
    if (!_userDataDictionary) {
        [self getUserData];
    }
    [[_userDataDictionary objectForKey:@"profile" ] setObject:username forKey:@"name"];
    [self saveUserData];
}

-(void)setUserEmail:(NSString *)email{
    if (!_userDataDictionary) {
        [self getUserData];
    }
    [_userDataDictionary setObject:email forKey:@"email"];
    [self saveUserData];
}

-(NSString *)getUserEmail{
    if (_userDataDictionary) {
        return [_userDataDictionary objectForKey:@"email"];
    }
    return [[self getUserData] objectForKey:@"email"];
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

-(NSString *)getUserAvatarUrl{
    if (_userDataDictionary) {
        return [[_userDataDictionary objectForKey:@"profile"] objectForKey:@"avatar_url"];
    }
    return [[[self getUserData] objectForKey:@"profile"] objectForKey:@"avatar_url"];
}

-(void)setUserAvatarImg:(UIImage*)avatar{
    NSData * data=UIImagePNGRepresentation(avatar);
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data forKey:@"avatar_url"];
    [userDefaults synchronize];
}
-(UIImage*)getUserAvatarImg{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [UIImage imageWithData:[userDefaults objectForKey:@"avatar_url"]];
}

-(BOOL)setDevToken:(NSString *)devToken{
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
        return [_userDataDictionary objectForKey:@"app_user_id"];
    }
    return [[self getUserData] objectForKey:@"app_user_id"];
}

- (void)setAppUserID:(NSString *)app_user_id{
    if (!_userDataDictionary) {
        [self getUserData];
    }
    [_userDataDictionary setObject:app_user_id forKey:@"app_user_id"];
    [self saveUserData];
}

- (void)setUserProvine:(NSString *)provine{
    if (!_userDataDictionary) {
        [self getUserData];
    }
    NSMutableDictionary *profile = [[_userDataDictionary objectForKey:@"profile"] mutableCopy];
    [profile setObject:provine forKey:@"provine"];
    [_userDataDictionary setObject:profile forKey:@"profile"] ;
    [self saveUserData];
}

- (NSString *)getUserProvine{
    if (_userDataDictionary) {
        return [[_userDataDictionary objectForKey:@"profile"] objectForKey:@"provine"];
    }
    return [[[self getUserData] objectForKey:@"profile"] objectForKey:@"provine"];
}

- (void)updateProfile:(NSMutableDictionary *)profileToUpdate{
    if(![self getToken] || [profileToUpdate count] == 0){
        return;
    }

    //Build user data to update
    
    [profileToUpdate setObject:[[UserData shareInstance] getToken] forKey:KeyAPI_TOKEN];
   
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
            [profileToUpdate setObject:@"" forKey:KeyAPI_ADDRESS];
        }
    }
    
    if(![profileToUpdate objectForKey:KeyAPI_AVATAR]){
        [profileToUpdate setObject:[[NSData alloc]init] forKey:KeyAPI_AVATAR];
    }else{
        UIImage *image = (UIImage *)[profileToUpdate objectForKey:KeyAPI_AVATAR];
        image = [UIUtils scaleImage:image toSize:CGSizeMake(200,200)];
        NSData *imageData = UIImagePNGRepresentation(image);
        [profileToUpdate setObject:imageData forKey:KeyAPI_AVATAR];
    }
    
    [[NetworkCommunicator shareInstance] POSTWithImage:API_UPDATE_PROFILE parameters:profileToUpdate onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
        NSLog(@"UPDATE_PROFILE");
        [profileToUpdate removeAllObjects];
    }];

}

- (void)updatePushSetting:(NSMutableDictionary *)infoToUpdate{
    if(![self getToken] || [infoToUpdate count] == 0){
        return;
    }
}

- (void)updateSocialSetting:(NSMutableDictionary *)infoToUpdate{
    if(![self getToken] || [infoToUpdate count] == 0){
        return;
    }
}


@end
