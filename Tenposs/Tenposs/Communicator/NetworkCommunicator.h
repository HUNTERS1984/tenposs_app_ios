//
//  LoginCommunicator.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/28/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossCommunicator.h"

@interface CommonResponse : JSONModel

@property (assign, nonatomic) NSInteger code;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSMutableDictionary *data;

@end


@interface NetworkCommunicator : TenpossCommunicator

@property (strong, nonatomic) NSString *request_url;

- (void)GET:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock;
- (void)GETWithoutPreDefined:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock;

- (void)POST:(NSString *)API parameters:(id)parameters delegate:(id)delegate;
- (void)POST:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock;
-(void)POSTWithImage:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock;
- (void)POSTWithoutAppId:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock;
-(void)POSTNoParams:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock;
-(void)POSTNoParamsV2:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock;
+(NetworkCommunicator *)shareInstance;

@end
