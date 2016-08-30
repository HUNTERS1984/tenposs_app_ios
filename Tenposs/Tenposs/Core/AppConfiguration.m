//
//  AppConfiguration.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/26/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "AppConfiguration.h"
#import "AppInfoCommunicator.h"
#import "MockupData.h"

@implementation AppInfo

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data.id":@"store_id",
                                                       @"data.name":@"name",
                                                       @"data.description":@"desc",
                                                       @"data.created_at":@"created_at",
                                                       @"data.status":@"status",
                                                       @"data.updated_at":@"updated_at",
                                                       @"data.top_components":@"top_components",
                                                       @"data.app_setting":@"app_setting",
                                                       @"data.side_menu":@"side_menu",
                                                       @"data.stores":@"stores"}];
}

@end

@implementation StoreModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"store_id"}];
}

@end

@implementation TopComponentModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"top_id"}];
}
@end

@implementation AppSettings
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{}];
}

@end

@implementation MenuModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"menu_id"}];
}

@end

@interface AppConfiguration()<TenpossCommunicatorDelegate>

@property (assign, nonatomic) CGFloat cellSpacing;

@property (assign, nonatomic) NSInteger numberOfProductColumn_iphone;
@property (assign, nonatomic) NSInteger numberOfProductColumn_ipad;

@property (assign, nonatomic) NSInteger numberOfPhotoColumn_iphone;
@property (assign, nonatomic) NSInteger numberOfPhotoColumn_ipad;

@property (strong, nonatomic) AppSettings *appSettings;
@property (strong, nonatomic) AppInfo *appInfo;

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
//TODO: clean
- (void)mockUp{
    if(self.completeHandler){
        //self.completeHandler([NSError errorWithDomain:@"This is Error" code:100 userInfo:nil]);
//        self.appSettings = [AppSettings new];
//        self.appSettings.template_id = 1;
        NSError *error = nil;
        NSDictionary *data = [MockupData fetchDictionaryWithResourceName:@"app_info"];
        if (data) {
            self.appInfo = [[AppInfo alloc] initWithDictionary:data error:&error];
        }
        self.completeHandler(error);
        self.completeHandler = nil;
    }
}

#pragma mark - Public methods
- (void)loadAppInfoWithCompletionHandler:(void(^)(NSError *error))handler{
    
    [self loadAppInfo];
    
    self.completeHandler = handler;
    
    //TODO: clean
    [self mockUp];
}

- (void)loadAppInfo{

}

- (NSArray <TopComponentModel *> *) getAvailableTopComponents{
    if (_appInfo.top_components != nil) {
        return _appInfo.top_components;
    }
    return nil;
}

- (NSArray<MenuModel *> *) getAvailableSideMenu{
    if (_appInfo.side_menu) {
        return _appInfo.side_menu;
    }
    return nil;
}

- (AppSettings *)getAvailableAppSettings{
    if (_appInfo.app_setting) {
        return _appInfo.app_setting;
    }
    return nil;
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
