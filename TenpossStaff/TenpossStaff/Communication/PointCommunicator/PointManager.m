//
//  PointManager.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 12/5/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "PointManager.h"
#import "Utils.h"
#import "Const.h"

NSString * const POINT_BASE_ADDRESS = @"https://apipoints.ten-po.com";
NSString * const POINT_USER_POINT = @"/point?";

@implementation PointManager

+(PointManager *)sharedInstance{
    
    static PointManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[PointManager alloc] init];
    });
    return _sharedInstance;
}

- (void)PointGetUserPointWithCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock{
    _request_url = [NSString stringWithFormat:@"%@%@",POINT_BASE_ADDRESS,POINT_USER_POINT];
    
    Bundle *body = [Bundle new];
    [body put:KeyAPI_APP_ID value:APP_ID];
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
        void (^callback)(BOOL isSuccess,NSDictionary *dictionary) = [responseParams get:KeyRequestCallback];
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
            NSLog(@"%@ - err: %ld", [params get:KeyRequestURL], (long)data.code);
        }else{
            [params put:KeyResponseResult value:@(data.code)];
            [params put:KeyResponseObject value:data];
        }
    }
}

@end
