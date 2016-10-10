//
//  GetPushSettingsCommunicator.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/5/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "GetPushSettingsCommunicator.h"

@implementation GetPushSettingsCommunicator
- (void)customPrepare:(Bundle *)params{
    NSString* strUrl = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddress],API_GETPUSHSETTING];
    strUrl = [strUrl stringByAppendingFormat:@"%@", [RequestBuilder requestBuilder:params]];
    [params put:KeyRequestURL value:strUrl];
}

- (void)customProcess:(Bundle *)params{
    NSError* error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&error];
    NSInteger code = [((NSNumber *)[dict objectForKey:@"code"]) integerValue];
    if(code != ERROR_OK){
        NSString* description = [CommunicatorConst getErrorMessage:code];
        [params put:KeyResponseResult value:@(code)];
        [m_pParams put:KeyResponseError value:description];
        NSLog(@"%@ - err: %ld", [params get:KeyRequestURL], (long)code);
    }else{
        [params put:KeyResponseResult value:@(code)];
        [params put:KeyResponseObject value:dict];
    }
}
@end
