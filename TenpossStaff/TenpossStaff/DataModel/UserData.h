//
//  UserData.h
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/27/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property(nonatomic,strong) NSMutableDictionary *userDataDictionary;
@property(nonatomic) BOOL isLogin;

+(UserData *)shareInstance;

- (BOOL)saveUserData;
- (void)clearUserData;
- (NSDictionary *)getUserData;

- (void)invalidateCurrentUser;

- (BOOL)saveTokenKit:(NSDictionary *)tokenKit;


-(NSString *)getToken;
-(NSString *)getHrefRefreshToken;

@end
