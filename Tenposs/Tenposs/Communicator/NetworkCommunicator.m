//
//  LoginCommunicator.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/28/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "NetworkCommunicator.h"
#import "Const.h"
#import "Utils.h"
#import <UIKit/UIKit.h>

@implementation CommonResponse

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end

@implementation NetworkCommunicator

+(NetworkCommunicator *)shareInstance{
    
    static NetworkCommunicator *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[NetworkCommunicator alloc] init];
    });
    return _sharedInstance;
}

- (void)POST:(NSString *)API parameters:(id)parameters delegate:(id)delegate{
    
    _request_url = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddress],API];

    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    NSArray *sigs = [NSArray arrayWithObjects:APP_ID,currentTime,APP_SECRET,nil];
    
    Bundle *body = [Bundle new];
    NSMutableDictionary *dictData = [parameters mutableCopy];
    [dictData setObject:APP_ID forKey:KeyAPI_APP_ID];
    [dictData setObject:currentTime forKey:KeyAPI_TIME];
    [dictData setObject:[Utils getSigWithStrings:sigs] forKey:KeyAPI_SIG];
    
    NSString *strData = [Utils makeParamtersString:dictData withEncoding:NSUTF8StringEncoding];
    NSData *req_data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    [body put:KeyRequestData value:req_data];
    
    [self execute:body withDelegate:delegate];
}

- (void)GET:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock
{
    _request_url = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddress],API];
    
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    NSArray *sigs = [NSArray arrayWithObjects:APP_ID,currentTime,APP_SECRET,nil];
    
    Bundle *body = [Bundle new];
    
    [body put:KeyAPI_APP_ID value:APP_ID];
    [body put:KeyAPI_TIME value:currentTime];
    [body put:KeyAPI_SIG value:[Utils getSigWithStrings:sigs]];

    for (NSString* key in parameters) {
        [body put:key value:[parameters objectForKey:key]];
    }
    [body put:KeyRequestCallback value:completeBlock];
    
    [self execute:body withDelegate:self];
}

- (void)GETWithoutPreDefined:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock{
    _request_url = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddress],API];
    
    if ([parameters isKindOfClass:[Bundle class]]) {
        Bundle *body = ((Bundle *)parameters);
        
        [body put:KeyRequestCallback value:completeBlock];
        
        [self execute:body withDelegate:self];
    }
}

- (void)POST:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock
{
    _request_url = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddress],API];
    
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    NSString *email = [parameters objectForKey:KeyAPI_EMAIL];
    NSArray *sigs = [NSArray arrayWithObjects:APP_ID,currentTime,email,APP_SECRET,nil];
    
    Bundle *body = [Bundle new];
    NSMutableDictionary *dictData = [parameters mutableCopy];
    [dictData setObject:APP_ID forKey:KeyAPI_APP_ID];
    [dictData setObject:currentTime forKey:KeyAPI_TIME];
    [dictData setObject:[Utils getSigWithStrings:sigs] forKey:KeyAPI_SIG];
    
    NSString *strData = [Utils makeParamtersString:dictData withEncoding:NSUTF8StringEncoding];
    NSData *req_data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    [body put:KeyRequestData value:req_data];
    [body put:KeyRequestCallback value:completeBlock];
    
    [self execute:body withDelegate:self];
}

- (void)POSTWithoutAppId:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock{
    _request_url = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddress],API];
    
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    NSArray *sigs = [NSArray arrayWithObjects:APP_ID,currentTime,APP_SECRET,nil];
    
    Bundle *body = [Bundle new];
    NSMutableDictionary *dictData = [parameters mutableCopy];
    [dictData setObject:currentTime forKey:KeyAPI_TIME];
    [dictData setObject:[Utils getSigWithStrings:sigs] forKey:KeyAPI_SIG];
    
    NSString *strData = [Utils makeParamtersString:dictData withEncoding:NSUTF8StringEncoding];
    NSData *req_data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    [body put:KeyRequestData value:req_data];
    [body put:KeyRequestCallback value:completeBlock];
    
    [self execute:body withDelegate:self];
}

-(void)POSTNoParamsV2:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock{
    _request_url = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddressV2],API];
    
    Bundle *body = [Bundle new];
    NSMutableDictionary *dictData = [parameters mutableCopy];
    
    NSString *strData = [Utils makeParamtersString:dictData withEncoding:NSUTF8StringEncoding];
    NSData *req_data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    [body put:KeyRequestData value:req_data];
    [body put:KeyRequestCallback value:completeBlock];
    
    [self execute:body withDelegate:self andAuthHeaderType:AuthenticationType_authorization];
}


-(void)POSTNoParams:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock{
    _request_url = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddress],API];

    Bundle *body = [Bundle new];
    NSMutableDictionary *dictData = [parameters mutableCopy];
    
    NSString *strData = [Utils makeParamtersString:dictData withEncoding:NSUTF8StringEncoding];
    NSData *req_data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    [body put:KeyRequestData value:req_data];
    [body put:KeyRequestCallback value:completeBlock];
    
    [self execute:body withDelegate:self];
}

-(void)POSTWithImage:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock{
    
    Bundle *params = [Bundle new];
    [params put:KeyRequestData value:parameters];
    [params put:KeyRequestCallback value:completeBlock];
    
    [self executeUpdateProfile:params withDelegate:self andAuthHeaderType:AuthenticationType_authorization];
}

- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
    NSError *error = nil;
    if (errorCode != ERROR_OK) {
        NSString *errorDomain = [CommunicatorConst getErrorMessage:errorCode];
        NSLog(@"request error: %@", errorDomain);
        
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
        void (^callback)(BOOL isSuccess,NSDictionary *dictionary) =[responseParams get:KeyRequestCallback];
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
            [params put:KeyResponseObject value:data.data];
        }
    }
}


@end
