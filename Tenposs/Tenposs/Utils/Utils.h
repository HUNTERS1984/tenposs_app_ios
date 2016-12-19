//
//  Utils.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/17/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#define HEXCOLOR(c)	[UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]
#define HEXCOLORA(c)	[UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:(c&0xFF)/255.0]

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface Utils : NSObject
+ (NSData *)sha256:(NSData *)data;
+ (NSString *)hashed_string:(NSString *)input;
+ (long long)currentTimeInMillis;
+ (NSString *)getSigWithStrings:(NSArray <NSString *> *)stringArray;
+ (NSString *)timeString;
+ (NSString *)stringForIcon:(UTF32Char)char32;

+ (NSString*)makeParamtersString:(NSDictionary*)parameters withEncoding:(NSStringEncoding)encoding;
+ (NSString *)URLEscaped:(NSString *)strIn withEncoding:(NSStringEncoding)encoding;

+ (NSString *)formatDateStringToJapaneseFormat:(NSString *)dateStr;
+ (NSString *)formatPriceToJapaneseFormat:(NSString *)oldPrice;

@end
