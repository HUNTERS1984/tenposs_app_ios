//
//  AppInfoCommunicator.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/3/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TenpossCommunicator.h"
#import "AppConfiguration.h"

@interface AppInfoResponse : JSONModel

@property (assign, nonatomic) NSInteger code;
@property (strong, nonatomic) NSString * message;
@property (strong, nonatomic) AppInfo *appInfo;

@end

@interface AppInfoCommunicator : TenpossCommunicator

@end
