//
//  Utils.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/17/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSData *)sha256:(NSData *)data {
    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    if ( CC_SHA256([data bytes], (int)[data length], hash) ) {
        NSData *sha256 = [NSData dataWithBytes:hash length:CC_SHA256_DIGEST_LENGTH];
        return sha256;
    }
    return nil;
}

+ (NSString *)hashed_string:(NSString *)input{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, (int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

+ (long long)currentTimeInMillis{
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    return milliseconds;
}

+ (NSString *)currentTimeString{
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    return [@(milliseconds) stringValue];
}

+(NSString *)timeString{
    
    NSInteger secondGmt = [[NSTimeZone systemTimeZone] secondsFromGMT];

    NSTimeZone *gmtZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    //[dateFormatter setTimeZone:gmtZone];
    NSDate * now = [NSDate date];
    NSInteger secondNow = gmtZone.secondsFromGMT;
    //NSString *timeStamp = [dateFormatter stringFromDate:[NSDate date]];
    //NSLog(@"%@",timeStamp);
    return nil;
}

+ (NSString *)getSigWithStrings:(NSArray <NSString *> *)stringArray{
    NSString *sig = @"";
    for (NSString *string in stringArray) {
        sig = [sig stringByAppendingString:string];
    }
    return [Utils hashed_string:sig];
}

@end
