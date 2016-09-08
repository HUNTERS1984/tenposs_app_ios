//
//  UserData.h
//  Moki
//
//  Created by MQ Solutions on 2/3/15.
//  Copyright (c) 2015 MQ Solutions. All rights reserved.
//

#import "EntityBase.h"
#import "UIKit/UIKit.h"


@interface UserData : EntityBase


@property(nonatomic,strong) NSMutableDictionary *userDataDictionary;
@property(nonatomic) BOOL isLogin;

+(UserData *)shareInstance;

-(BOOL)saveUserData;
-(void)clearUserData;
-(BOOL)shouldShowLogin;
-(NSDictionary *)getUserData;
-(NSString *)getToken;
-(NSString *) getUserID;
-(NSString *)getUserName;
-(NSString *)getUserAvatarUrl;
-(void) setUserName:(NSString*)userName;
-(UIImage*) getUserAvatarImg;
-(void) setUserAvatarImg:(UIImage*)avatar;
-(BOOL)setDevToken:(NSString *)devToken;
-(NSString *)getDevToken;

@end
