//
//  PointManager.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 12/5/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossCommunicator.h"
#import "NetworkCommunicator.h"

@interface PointManager : TenpossCommunicator

@property (strong, nonatomic) NSString *request_url;

+(PointManager *) sharedInstance;

- (void)PointGetUserPointWithCompleteBlock:(void (^)(BOOL isSuccess, NSDictionary *resultData))completeBlock;

@end
