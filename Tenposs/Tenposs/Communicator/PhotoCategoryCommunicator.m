//
//  PhotoCategoryCommunicator.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/31/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "PhotoCategoryCommunicator.h"


@implementation PhotoCategoryResponse
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data.photo_categories":@"items"}];
}

@end

@implementation PhotoCategoryCommunicator
- (void)customPrepare:(Bundle *)params{
    NSString* strUrl = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddress],API_PHOTO_CAT];
    strUrl = [strUrl stringByAppendingFormat:@"%@", [RequestBuilder requestBuilder:params]];
    [params put:KeyRequestURL value:strUrl];
}

- (void)customProcess:(Bundle *)params{
    NSError* error = nil;
    PhotoCategoryResponse* data = nil;
    @try {
        data = [[PhotoCategoryResponse alloc] initWithData:self.responseData error:&error];
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
            [params put:KeyResponseObject value:data];
        }
    }
}

@end
