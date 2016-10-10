//
//  ReserveCommunicator.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/5/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "ReserveCommunicator.h"

@implementation ReserveResponse

- (instancetype)init
{
    self = [super init];
    if (self) {
        _reserve = (NSMutableArray <ReserveObject> *)[NSMutableArray new];
    }
    return self;
}

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data.reserve":@"reserve"}];
}

@end

@implementation ReserveCommunicator

- (void)customPrepare:(Bundle *)params{
    NSString* strUrl = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddress],API_RESERVE];
    strUrl = [strUrl stringByAppendingFormat:@"%@", [RequestBuilder requestBuilder:params]];
    [params put:KeyRequestURL value:strUrl];
}

- (void)customProcess:(Bundle *)params{
    NSError* error = nil;
    ReserveResponse* data = nil;
    @try {
        data = [[ReserveResponse alloc] initWithData:self.responseData error:&error];
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
