//
//  AppConfiguration.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/26/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "AppConfiguration.h"

@interface AppConfiguration()

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

@end
