//
//  AppConfiguration.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/26/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "AppConfiguration.h"
#import "AppInfoCommunicator.h"

@implementation AppInfo

@end

@implementation AppSettings

@end

@interface AppConfiguration()<TenpossCommunicatorDelegate>

@end

@implementation AppConfiguration

+ (instancetype) sharedInstance{
    static AppConfiguration *counter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        counter = [[AppConfiguration alloc]init];
    });
    return counter;
}

- (instancetype) init{
    self = [super init];
    if (self) {
        [self defaultInit];
    }
    return self;
}

///Default Initialize
-(void)defaultInit{
    //TODO: need define default properties
    self.cellSpacing = 8;
}

- (void)loadAppInfoWithCompletionHandler:(void(^)(NSError *error))handler{
    
    [self loadAppInfo];
    
    self.completeHandler = handler;
    
    //TODO: clean
    [self mockUp];
}

- (void)loadAppInfo{
}

//TODO: clean
- (void)mockUp{
    if(self.completeHandler){
        //self.completeHandler([NSError errorWithDomain:@"This is Error" code:100 userInfo:nil]);
        self.appSettings = [AppSettings new];
        self.appSettings.template_id = 1;
        self.completeHandler(nil);
    }
}

#pragma mark - TenpossCommunicatorDelegate

- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    NSError *error = nil;
    if ([responseParams get:KeyResponseResult] != 0) {
        NSInteger errorCode = [[responseParams get:KeyResponseResult] integerValue];
        NSString *errorDomain = [responseParams get:KeyResponseError];
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
    }
    if (self.completeHandler) {
        self.completeHandler(error);
    }else{
        //This should never happen
        NSAssert(self.completeHandler==nil, @"CompleteHandler cannot be nil");
    }
}

- (void)begin:(TenpossCommunicator*)request data:(Bundle*) responseParams{

}

-( void)cancelAllRequest{
    
}


@end
