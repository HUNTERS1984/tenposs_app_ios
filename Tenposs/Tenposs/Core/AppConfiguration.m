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
#import "Const.h"
#import "Utils.h"
#import "CommunicatorConst.h"
#import "UserData.h"

@implementation AppInfo

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"store_id",
                                                       @"name":@"name",
                                                       @"description":@"desc",
                                                       @"created_at":@"created_at",
                                                       @"status":@"status",
                                                       @"updated_at":@"updated_at",
                                                       @"top_components":@"top_components",
                                                       @"app_setting":@"app_setting",
                                                       @"side_menu":@"side_menu",
                                                       @"stores":@"stores"}];
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

#pragma mark - Public methods
- (void)loadAppInfoWithCompletionHandler:(void(^)(NSError *error))handler{
    [self loadAppInfo];
    if (!handler) {
        NSAssert(false, @"Handler cannot be nil!");
    }
    self.completeHandler = handler;
}

- (void)loadAppInfo{
    AppInfoCommunicator *request = [AppInfoCommunicator new];
    Bundle *params = [Bundle new];
    [params put:KeyAPI_APP_ID value:APP_ID];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    [params put:KeyAPI_TIME value:currentTime];
    NSArray *strings = [NSArray arrayWithObjects:APP_ID,currentTime,APP_SECRET,nil];
    [params put:KeyAPI_SIG value:[Utils getSigWithStrings:strings]];
    [request execute:params withDelegate:self];
}

- (void)requestCompleteWithError:(NSError *)error{
    if (self.completeHandler) {
        self.completeHandler(error);
    }else{
        //This should never happen
        NSAssert(self.completeHandler==nil, @"CompleteHandler cannot be nil");
    }
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

- (NSString *)getStoreId{
    
    ///TODO: need fixed!
    
    NSInteger storeId = ((StoreModel *)[self.appInfo.stores firstObject]).store_id;
    return [@(storeId) stringValue];
}

-(NSArray <NSNumber *> *)getStoryIdArray{
    NSMutableArray<NSNumber *> *array = (NSMutableArray<NSNumber *> *)[NSMutableArray new];
    for (StoreModel *store in _appInfo.stores) {
        [array addObject:@(store.store_id)];
    }
    return [array mutableCopy];
}

#pragma mark - TenpossCommunicatorDelegate

- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    NSError *error = nil;
    NSInteger result = [responseParams getInt:KeyResponseResult];
    if (result != ERROR_OK) {
        NSInteger errorCode = [[responseParams get:KeyResponseResult] integerValue];
        NSString *errorDomain = [responseParams get:KeyResponseError];
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
    }else{
        _appInfo = (AppInfo *)[responseParams get:KeyResponseObject];
    }
    [self requestCompleteWithError:error];
}

- (void)begin:(TenpossCommunicator*)request data:(Bundle*) responseParams{

}

-( void)cancelAllRequest{
    
}

@end
