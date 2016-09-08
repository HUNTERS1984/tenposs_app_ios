//
//  TenpossCommunicator.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/28/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossCommunicator.h"

@implementation TenpossCommunicator

-(void) prepare:(Bundle*) params
{
    if(self.cancelled == YES)
        return;
    //g_strCookie = @"";
    if([self respondsToSelector:@selector(customPrepare:)])
        [self customPrepare:params];
}
-(void) process:(Bundle*) params
{
    if(self.cancelled == YES)
        return;
    if([self respondsToSelector:@selector(customProcess:)])
        [self customProcess:params];
}



-(void) execute:(Bundle*) params withDelegate:(id) delegate
{
    self.delegate = delegate;
    m_pParams = params;
    [self prepare:params];
    NSString* url = [m_pParams get:KeyRequestURL];
    
    NSData* requestData = [params get:KeyRequestData];
    if(requestData == nil) {
        m_pRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        //TODO: support Cookie???
        /*
         if([g_strCookie length] > 0)
         [m_pRequest addValue:g_strCookie forHTTPHeaderField:@"Cookie"];
         */
    }else{
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[requestData length]];
        m_pRequest = [[NSMutableURLRequest alloc] init];
        [m_pRequest setURL:[NSURL URLWithString:url]];
        [m_pRequest setHTTPMethod:@"POST"];
        
        [m_pRequest setValue:@"application/json, text/javascript, */*; q=0.01" forHTTPHeaderField:@"Accept"];
        [m_pRequest setValue:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.154 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
        [m_pRequest setValue:@"en-US,en;q=0.8,vi;q=0.6" forHTTPHeaderField:@"Accept-Language"];
        [m_pRequest setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
        [m_pRequest setValue:@"no-cache" forHTTPHeaderField:@"Pragma"];
        [m_pRequest setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
        [m_pRequest setValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
        [m_pRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [m_pRequest setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [m_pRequest setHTTPBody:requestData];
    }
    
    // Create url connection and fire request
    NSInteger timeout = [params getInt:KeyRequestTimeout];
    if(timeout <= 0)
        timeout = 15;
    [m_pRequest setTimeoutInterval:timeout];
    
    m_pConnection = [[NSURLConnection alloc] initWithRequest:m_pRequest delegate:self];
    [m_pConnection start];
    NSLog(@"Start NSURLConnection: %@ - %@", NSStringFromClass([self class]), m_pRequest.URL);
    
}
-(void)     cancelRequest
{
    NSLog(@"%@ cancel", NSStringFromClass([self class]));
    if(m_pConnection != nil){
        [m_pConnection cancel];
    }
    self.cancelled = YES;
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
            [self process:m_pParams];
        }else{
            NSString* description = [NSString stringWithFormat:@"Server error: %ld - %@", (long)self.httpCode, [NSHTTPURLResponse localizedStringForStatusCode:self.httpCode]];
            [m_pParams put:KeyResponseResult value:@(ResultErrorUnknown)];
            [m_pParams put:KeyResponseError value:description];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    NSLog(@"End NSURLConnection : %@ - cancel : %d", NSStringFromClass([self class]), self.cancelled);
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(completed:data:)] && self.cancelled == NO)
    {
        [self.delegate completed:self data:m_pParams];
    }
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
    description = NSLocalizedString(str, [error localizedDescription]);
    [m_pParams put:KeyResponseResult value:@(ResultErrorConnection)];
    [m_pParams put:KeyResponseResultFromNetwork value:@(errorCode)];
    //[m_pParams put:KeyResponseError value:[error localizedDescription]];
    [m_pParams put:KeyResponseError value:description];
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(completed:data:)] && self.cancelled == NO)
    {
        [self.delegate completed:self data:m_pParams];
    }
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