//
//  Utils.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/17/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface Utils : NSObject
+ (NSData *)sha256:(NSData *)data;
+ (NSString *)hashed_string:(NSString *)input;
+ (long long)currentTimeInMillis;
+ (NSString *)getSigWithStrings:(NSArray <NSString *> *)stringArray;
+(NSString *)timeString;
@end
