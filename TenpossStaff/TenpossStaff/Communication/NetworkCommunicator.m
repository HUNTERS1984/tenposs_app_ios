//
//  LoginCommunicator.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/28/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "NetworkCommunicator.h"
#import "Utils.h"
#import <UIKit/UIKit.h>
#import "RequestBuilder.h"
#import "Const.h"

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
    
    NSString *strData = [self makeParamtersString:dictData withEncoding:NSUTF8StringEncoding];
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

- (void)POSTWithoutAppId:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock
{
    _request_url = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddress],API];
    
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    NSArray *sigs = [NSArray arrayWithObjects:APP_ID,currentTime,APP_SECRET,nil];
    
    Bundle *body = [Bundle new];
    NSMutableDictionary *dictData = [parameters mutableCopy];
    [dictData setObject:currentTime forKey:KeyAPI_TIME];
    [dictData setObject:[Utils getSigWithStrings:sigs] forKey:KeyAPI_SIG];
    
    NSString *strData = [self makeParamtersString:dictData withEncoding:NSUTF8StringEncoding];
    NSData *req_data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    [body put:KeyRequestData value:req_data];
    [body put:KeyRequestCallback value:completeBlock];
    
    [self execute:body withDelegate:self];
}

-(void)POSTNoParamsV2:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock{
    _request_url = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddressV2],API];
    
    Bundle *body = [Bundle new];
    NSMutableDictionary *dictData = [parameters mutableCopy];
    
    NSString *strData = [self makeParamtersString:dictData withEncoding:NSUTF8StringEncoding];
    NSData *req_data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    [body put:KeyRequestData value:req_data];
    [body put:KeyRequestCallback value:completeBlock];
    
    [self execute:body withDelegate:self andAuthHeaderType:AuthenticationType_authorization];
}

-(void)POSTNoParams:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock{
    _request_url = [NSString stringWithFormat:@"%@%@",BASE_ADDRESS,API];

    Bundle *body = [Bundle new];
    NSMutableDictionary *dictData = [parameters mutableCopy];
    
    NSString *strData = [self makeParamtersString:dictData withEncoding:NSUTF8StringEncoding];
    NSData *req_data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
    [body put:KeyRequestData value:req_data];
    [body put:KeyRequestCallback value:completeBlock];
    
    [self execute:body withDelegate:self];
}

-(void)POSTWithImage:(NSString *)API parameters:(id)parameters onCompleted:(void (^)(BOOL isSuccess,NSDictionary *dictionary)) completeBlock{
    
    _request_url = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddress],API_UPDATE_PROFILE];
    
    m_pRequest = [[NSMutableURLRequest alloc] init];
    [m_pRequest setHTTPShouldHandleCookies:NO];
    [m_pRequest setTimeoutInterval:60];
    [m_pRequest setHTTPMethod:@"POST"];

    NSString *boundary = @"------TenpossIOSAPP_BOUND";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [m_pRequest setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
//    Bundle *body = [Bundle new];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    NSArray *sigs = [NSArray arrayWithObjects:APP_ID,currentTime,APP_SECRET,nil];
    NSMutableDictionary *dictData = [parameters mutableCopy];
    [dictData setObject:[APP_ID dataUsingEncoding:NSUTF8StringEncoding] forKey:KeyAPI_APP_ID];
    [dictData setObject:[currentTime dataUsingEncoding:NSUTF8StringEncoding] forKey:KeyAPI_TIME];
    [dictData setObject:[[Utils getSigWithStrings:sigs] dataUsingEncoding:NSUTF8StringEncoding] forKey:KeyAPI_SIG];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    NSData *imageData = nil;
    
    for (NSString *param in dictData.allKeys) {
        if ([param isEqualToString:KeyAPI_AVATAR]) {
            
            imageData = (NSData *)[dictData objectForKey:KeyAPI_AVATAR];
        
        }else{
            NSString *key = param;
            if ([param isEqualToString:@"avatar"]) {
                continue;
            }else if([param isEqualToString:@"\"app_id\""]){
                key = @"app_id";
            }
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dictData objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];

//            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"n", param] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[[NSString stringWithFormat:@"%@\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    NSString *imageName = @"avatar";
    
    if (imageData) {
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", imageName] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"Content-Type:image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:imageData];
//        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];

        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"avatar\"; filename=\"image.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    }
    
    
    //Close off the request with the boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[body length]];
//    [m_pRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [m_pRequest setHTTPBody:body];
    
    // set URL
    NSLog(@"UPDATE PROFILE - %@", body);
    [m_pRequest setURL:[NSURL URLWithString:_request_url]];
    m_pConnection = [[NSURLConnection alloc] initWithRequest:m_pRequest delegate:self];
    [m_pConnection start];
    NSLog(@"Start NSURLConnection: %@ - %@", NSStringFromClass([self class]), m_pRequest.URL);
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


- (NSString*)makeParamtersString:(NSDictionary*)parameters withEncoding:(NSStringEncoding)encoding
{
    if (nil == parameters || [parameters count] == 0)
        return nil;
    
    NSMutableString* stringOfParamters = [[NSMutableString alloc] init];
    NSEnumerator *keyEnumerator = [parameters keyEnumerator];
    id key = nil;
    while ((key = [keyEnumerator nextObject]))
    {
        if([[parameters valueForKey:key] isKindOfClass:[NSData class]]){
            
        }else{
            NSString *value = [[parameters valueForKey:key] isKindOfClass:[NSString class]] ?
            [parameters valueForKey:key] : [[parameters valueForKey:key] stringValue];
            [stringOfParamters appendFormat:@"%@=%@&",
            [self URLEscaped:key withEncoding:encoding],
            [self URLEscaped:value withEncoding:encoding]];
        }
        
    }
    
    // Delete last character of '&'
    NSRange lastCharRange = {[stringOfParamters length] - 1, 1};
    [stringOfParamters deleteCharactersInRange:lastCharRange];
    return stringOfParamters;
}

- (NSString *)URLEscaped:(NSString *)strIn withEncoding:(NSStringEncoding)encoding{
    
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
        NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
        
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
