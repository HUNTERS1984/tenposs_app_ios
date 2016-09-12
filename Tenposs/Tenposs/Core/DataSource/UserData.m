//
//  UserData.m
//  Moki
//
//  Created by MQ Solutions on 2/3/15.
//  Copyright (c) 2015 MQ Solutions. All rights reserved.
//

#import "UserData.h"

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
    
    [[_userDataDictionary objectForKey:@"profile" ] setObject:[@(gender) stringValue] forKey:@"gender"];
    [self saveUserData];
}

- (NSString *)getUserGenderString{
    if (_userDataDictionary) {
        NSString *gender = (NSString *)[[_userDataDictionary objectForKey:@"profile"] objectForKey:@"gender"];
        NSInteger genderInt = [gender integerValue];
        if (genderInt == GENDER_MALE) {
            //TODO: need localize
            return @"Male";
        }else if (genderInt == GENDER_MALE) {
            return @"Female";
        }
    }
    NSString *gender = (NSString *)[[[self getUserData] objectForKey:@"profile"] objectForKey:@"gender"];
    NSInteger genderInt = [gender integerValue];
    if (genderInt == GENDER_MALE) {
        //TODO: need localize
        return @"Male";
    }else if (genderInt == GENDER_MALE) {
        return @"Female";
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



@end
