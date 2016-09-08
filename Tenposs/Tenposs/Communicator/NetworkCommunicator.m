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

- (void)POST:(NSString *)API parameters:(id)parameters delegate:(id)delegate
{
    _request_url = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddress],API];
    
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    NSArray *sigs = [NSArray arrayWithObjects:APP_ID,currentTime,APP_SECRET,nil];
    
    Bundle *body = [Bundle new];
    NSMutableDictionary *dictData = [parameters mutableCopy];
    [dictData setObject:APP_ID forKey:KeyAPI_APP_ID];
    [dictData setObject:currentTime forKey:KeyAPI_TIME];
    [dictData setObject:[Utils getSigWithStrings:sigs] forKey:KeyAPI_SIG];
    
    NSString *strData = [self makeParamtersString:dictData withEncoding:NSUTF8StringEncoding];
    NSData *req_data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    [body put:KeyRequestData value:req_data];
    
    [self execute:body withDelegate:delegate];
}

- (void)POST:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock
{
    _request_url = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddress],API];
    
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    NSArray *sigs = [NSArray arrayWithObjects:APP_ID,currentTime,APP_SECRET,nil];
    
    Bundle *body = [Bundle new];
    NSMutableDictionary *dictData = [parameters mutableCopy];
    [dictData setObject:APP_ID forKey:KeyAPI_APP_ID];
    [dictData setObject:currentTime forKey:KeyAPI_TIME];
    [dictData setObject:[Utils getSigWithStrings:sigs] forKey:KeyAPI_SIG];
    
    NSString *strData = [self makeParamtersString:dictData withEncoding:NSUTF8StringEncoding];
    NSData *req_data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    [body put:KeyRequestData value:req_data];
    [body put:KeyRequestCallback value:completeBlock];
    
    [self execute:body withDelegate:self];
}

- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams
{
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


- (NSString*)makeParamtersString:(NSDictionary*)parameters withEncoding:(NSStringEncoding)encoding
{
    if (nil == parameters || [parameters count] == 0)
        return nil;
    
    NSMutableString* stringOfParamters = [[NSMutableString alloc] init];
    NSEnumerator *keyEnumerator = [parameters keyEnumerator];
    id key = nil;
    while ((key = [keyEnumerator nextObject]))
    {
        NSString *value = [[parameters valueForKey:key] isKindOfClass:[NSString class]] ?
        [parameters valueForKey:key] : [[parameters valueForKey:key] stringValue];
        [stringOfParamters appendFormat:@"%@=%@&",
         [self URLEscaped:key withEncoding:encoding],
         [self URLEscaped:value withEncoding:encoding]];
    }
    
    // Delete last character of '&'
    NSRange lastCharRange = {[stringOfParamters length] - 1, 1};
    [stringOfParamters deleteCharactersInRange:lastCharRange];
    return stringOfParamters;
}

- (NSString *)URLEscaped:(NSString *)strIn withEncoding:(NSStringEncoding)encoding
{
    CFStringRef escaped = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)strIn, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", CFStringConvertNSStringEncodingToEncoding(encoding));
    NSString *strOut = [NSString stringWithString:(__bridge NSString *)escaped];
    CFRelease(escaped);
    return strOut;
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
