//
//  PushNotificationManager.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 12/5/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossCommunicator.h"
#import "NetworkCommunicator.h"

@interface PushNotificationManager : TenpossCommunicator <TenpossCommunicatorDelegate>

@property (strong, nonatomic) NSString *request_url;

+(PushNotificationManager *) sharedInstance;

- (void)PushUserSetPushKey:(NSString *)key WithCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock;

- (void)PushSetUserPushSettings:(NSMutableDictionary *)pushData WithCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock;

- (void)PushGetUserPushSettingsWithCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock;

@end
