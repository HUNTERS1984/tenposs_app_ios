//
//  UpdateProfileCommunicator.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/28/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "UpdateProfileCommunicator.h"
#import "Const.h"
#import "Utils.h"
#import "NetworkCommunicator.h"

@implementation UpdateProfileCommunicator

-(void)execute:(id)parameters{
    
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

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is ≈called each time there is a redirect so reinitializing it
    // also serves to clear it
    
    self.httpCode = ((NSHTTPURLResponse*)response).statusCode;
    self.responseData = [[NSMutableData alloc] init];
    //	NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    //   NSDictionary *fields = [HTTPResponse allHeaderFields];
    //  NSString *cookie = [fields valueForKey:@"Set-Cookie"]; // It is your cookie
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [self.responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    @try {
        //TODO: return data to delegate
        if( self.httpCode == 200 ){
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
            
            if(error != nil){
                NSLog(@"%@", error);
                //TODO: real error code
                
            }else{
                if(data.code != ERROR_OK){
                    NSString* description = [CommunicatorConst getErrorMessage:data.code];
                    
                }else{
             
                }
            }
            
        }else{
        
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    NSLog(@"End NSURLConnection : %@ - cancel : %d", NSStringFromClass([self class]), self.cancelled);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    NSInteger errorCode = [error code];
    NSString* description = @"";
    NSString* str = @"";
    switch (errorCode) {
        case NSURLErrorUnknown:{
            str = @"NSURLErrorUnknown";
        }break;
        case NSURLErrorCancelled:{
            str = @"NSURLErrorCancelled";
        }break;
        case NSURLErrorBadURL:{
            str = @"NSURLErrorBadURL";
        }break;
        case NSURLErrorTimedOut:{
            str = @"NSURLErrorTimedOut";
        }break;
        case NSURLErrorUnsupportedURL:{
            str = @"NSURLErrorUnsupportedURL";
        }break;
        case NSURLErrorCannotFindHost:{
            str = @"NSURLErrorCannotFindHost";
        }break;
        case NSURLErrorCannotConnectToHost:{
            str = @"NSURLErrorCannotConnectToHost";
        }break;
        case NSURLErrorNetworkConnectionLost:{
            str = @"NSURLErrorNetworkConnectionLost";
        }break;
        case NSURLErrorDNSLookupFailed:{
            str = @"NSURLErrorDNSLookupFailed";
        }break;
        case NSURLErrorHTTPTooManyRedirects:{
            str = @"NSURLErrorHTTPTooManyRedirects";
        }break;
        case NSURLErrorResourceUnavailable:{
            str = @"NSURLErrorResourceUnavailable";
        }break;
        case NSURLErrorNotConnectedToInternet:{
            str = @"NSURLErrorNotConnectedToInternet";
        }break;
        case NSURLErrorRedirectToNonExistentLocation:{
            str = @"NSURLErrorRedirectToNonExistentLocation";
        }break;
        case NSURLErrorBadServerResponse:{
            str = @"NSURLErrorBadServerResponse";
        }break;
        case NSURLErrorUserCancelledAuthentication:{
            str = @"NSURLErrorUserCancelledAuthentication";
        }break;
        case NSURLErrorUserAuthenticationRequired:{
            str = @"NSURLErrorUserAuthenticationRequired";
        }break;
        case NSURLErrorZeroByteResource:{
            str = @"NSURLErrorZeroByteResource";
        }break;
        case NSURLErrorCannotDecodeRawData:{
            str = @"NSURLErrorCannotDecodeRawData";
        }break;
        case NSURLErrorCannotDecodeContentData:{
            str = @"NSURLErrorCannotDecodeContentData";
        }break;
        case NSURLErrorCannotParseResponse:{
            str = @"NSURLErrorCannotParseResponse";
        }break;
        case NSURLErrorAppTransportSecurityRequiresSecureConnection:{
            str = @"NSURLErrorAppTransportSecurityRequiresSecureConnection";
        }break;
        case NSURLErrorFileDoesNotExist:{
            str = @"NSURLErrorFileDoesNotExist";
        }break;
        case NSURLErrorFileIsDirectory:{
            str = @"NSURLErrorFileIsDirectory";
        }break;
        case NSURLErrorNoPermissionsToReadFile:{
            str = @"NSURLErrorNoPermissionsToReadFile";
        }break;
        case NSURLErrorDataLengthExceedsMaximum:{
            str = @"NSURLErrorDataLengthExceedsMaximum";
        }break;
        case NSURLErrorSecureConnectionFailed:{
            str = @"NSURLErrorSecureConnectionFailed";
        }break;
        case NSURLErrorServerCertificateHasBadDate:{
            str = @"NSURLErrorServerCertificateHasBadDate";
        }break;
        case NSURLErrorServerCertificateUntrusted:{
            str = @"NSURLErrorServerCertificateUntrusted";
        }break;
        case NSURLErrorServerCertificateHasUnknownRoot:{
            str = @"NSURLErrorServerCertificateHasUnknownRoot";
        }break;
        case NSURLErrorServerCertificateNotYetValid:{
            str = @"NSURLErrorServerCertificateNotYetValid";
        }break;
        case NSURLErrorClientCertificateRejected:{
            str = @"NSURLErrorClientCertificateRejected";
        }break;
        case NSURLErrorClientCertificateRequired:{
            str = @"NSURLErrorClientCertificateRequired";
        }break;
        case NSURLErrorCannotLoadFromNetwork:{
            str = @"NSURLErrorCannotLoadFromNetwork";
        }break;
        case NSURLErrorCannotCreateFile:{
            str = @"NSURLErrorCannotCreateFile";
        }break;
        case NSURLErrorCannotOpenFile:{
            str = @"NSURLErrorCannotOpenFile";
        }break;
        case NSURLErrorCannotCloseFile:{
            str = @"NSURLErrorCannotCloseFile";
        }break;
        case NSURLErrorCannotWriteToFile:{
            str = @"NSURLErrorCannotWriteToFile";
        }break;
        case NSURLErrorCannotRemoveFile:{
            str = @"NSURLErrorCannotRemoveFile";
        }break;
        case NSURLErrorCannotMoveFile:{
            str = @"NSURLErrorCannotMoveFile";
        }break;
        case NSURLErrorDownloadDecodingFailedMidStream:{
            str = @"NSURLErrorDownloadDecodingFailedMidStream";
        }break;
        case NSURLErrorDownloadDecodingFailedToComplete:{
            str = @"NSURLErrorDownloadDecodingFailedToComplete";
        }break;
        case NSURLErrorInternationalRoamingOff:{
            str = @"NSURLErrorInternationalRoamingOff";
        }break;
        case NSURLErrorCallIsActive:{
            str = @"NSURLErrorCallIsActive";
        }break;
        case NSURLErrorDataNotAllowed:{
            str = @"NSURLErrorDataNotAllowed";
        }break;
        case NSURLErrorRequestBodyStreamExhausted:{
            str = @"NSURLErrorRequestBodyStreamExhausted";
        }break;
        case NSURLErrorBackgroundSessionRequiresSharedContainer:{
            str = @"NSURLErrorBackgroundSessionRequiresSharedContainer";
        }break;
        case NSURLErrorBackgroundSessionInUseByAnotherProcess:{
            str = @"NSURLErrorBackgroundSessionInUseByAnotherProcess";
        }break;
        case NSURLErrorBackgroundSessionWasDisconnected:{
            str = @"NSURLErrorBackgroundSessionWasDisconnected";
        }break;
            
        default:
            str = @"General Error";
            errorCode = ResultErrorUnknown;
            
            break;
    }
    
    //TODO: error request update profile
    
}


-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        NSLog(@"Ignoring SSL");
        SecTrustRef trust = challenge.protectionSpace.serverTrust;
        NSURLCredential *cred;
        cred = [NSURLCredential credentialForTrust:trust];
        [challenge.sender useCredential:cred forAuthenticationChallenge:challenge];
        return;
    }
    
    // Provide your regular login credential if needed...
}

@end
