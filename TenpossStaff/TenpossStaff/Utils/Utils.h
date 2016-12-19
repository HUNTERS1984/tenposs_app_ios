//
//  Utils.h
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/13/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

@interface Utils : NSObject

+ (UIStoryboard *)mainStoryboard;

+ (NSDate *)convertDateFromString:(NSString *)dateString;

+ (NSString *)relativeDateStringForDate:(NSDate *)date;

+ (long long)currentTimeInMillis;

+ (NSString *)hashed_string:(NSString *)input;

+ (NSData *)sha256:(NSData *)data;

+ (NSString *)getSigWithStrings:(NSArray <NSString *> *)stringArray;

+ (NSString*)makeParamtersString:(NSDictionary*)parameters withEncoding:(NSStringEncoding)encoding;

@end
