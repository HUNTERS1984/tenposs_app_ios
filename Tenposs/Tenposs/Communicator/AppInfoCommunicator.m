//
//  AppInfoCommunicator.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/3/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "AppInfoCommunicator.h"
#import "AppConfiguration.h"


@implementation AppInfoResponse

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data":@"appInfo",
                                                       }];
}

@end

@implementation AppInfoCommunicator

- (void)customPrepare:(Bundle *)params{
    NSString* strUrl = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddress],API_APPINFO];
    strUrl = [strUrl stringByAppendingFormat:@"%@", [RequestBuilder requestBuilder:params]];
    [params put:KeyRequestURL value:strUrl];
}

- (void)customProcess:(Bundle *)params{
    
    NSError* error = nil;
    AppInfoResponse* data = nil;
    @try {
        data = [[AppInfoResponse alloc] initWithData:self.responseData error:&error];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        
    }
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
            [params put:KeyResponseObject value:data.appInfo];
        }
    }
}

@end
