//
//  StaffCommunicator.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/11/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "StaffCommunicator.h"

@implementation StaffResponse

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data.staffs":@"staffs",
                                                       @"data.total_staffs":@"total_staffs"
                                                       }];
}
@end


@implementation StaffCommunicator
- (void)customPrepare:(Bundle *)params{
    NSString* strUrl = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddress],API_STAFF];
    strUrl = [strUrl stringByAppendingFormat:@"%@", [RequestBuilder requestBuilder:params]];
    [params put:KeyRequestURL value:strUrl];
}

- (void)customProcess:(Bundle *)params{
    NSError* error = nil;
    StaffResponse* data = nil;
    @try {
        data = [[StaffResponse alloc] initWithData:self.responseData error:&error];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        
    }
    if( error != nil){
        NSLog(@"%@", error);
        //TODO: real error code
        [params put:KeyResponseResult value:@(ERROR_JSON_PARSER)];
    }else{
        if (!data) {
            [params put:KeyResponseResult value:@(ERROR_UNKNOWN)];
            [params put:KeyResponseObject value:data];
            return;
        }
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
