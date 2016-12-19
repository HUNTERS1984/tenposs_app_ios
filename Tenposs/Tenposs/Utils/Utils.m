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

+(NSString *)stringForIcon:(UTF32Char)char32
{
    if ((char32 & 0xFFFF0000) != 0)
        return [self stringFromUTF32Char:char32];
    else
        return [self stringFromUTF16Char:(UTF16Char)(char32&0xFFFF)];
}

+(NSString *)stringFromUTF32Char:(UTF32Char)char32
{
    char32 -= 0x10000;
    unichar highSurrogate = (unichar)(char32 >> 10); // leave the top 10 bits
    highSurrogate += 0xD800;
    unichar lowSurrogate = char32 & 0x3FF; // leave the low 10 bits
    lowSurrogate += 0xDC00;
    return [NSString stringWithCharacters:(unichar[]){highSurrogate, lowSurrogate} length:2];
}

+(NSString *)stringFromUTF16Char:(UTF16Char)char16
{
    return [NSString stringWithCharacters:(unichar[]){char16} length:1];
}

+ (NSString*)makeParamtersString:(NSDictionary*)parameters withEncoding:(NSStringEncoding)encoding
{
    if (nil == parameters || [parameters count] == 0)
        return nil;
    
    NSMutableString* stringOfParamters = [[NSMutableString alloc] init];
    NSEnumerator *keyEnumerator = [parameters keyEnumerator];
    id key = nil;
    while ((key = [keyEnumerator nextObject]))
    {
        if([[parameters valueForKey:key] isKindOfClass:[NSData class]]){
            
        }else{
            NSString *value = [[parameters valueForKey:key] isKindOfClass:[NSString class]] ?
            [parameters valueForKey:key] : [[parameters valueForKey:key] stringValue];
            [stringOfParamters appendFormat:@"%@=%@&",
             [self URLEscaped:key withEncoding:encoding],
             [self URLEscaped:value withEncoding:encoding]];
        }
        
    }
    
    // Delete last character of '&'
    NSRange lastCharRange = {[stringOfParamters length] - 1, 1};
    [stringOfParamters deleteCharactersInRange:lastCharRange];
    return stringOfParamters;
}

+ (NSString *)URLEscaped:(NSString *)strIn withEncoding:(NSStringEncoding)encoding{
    
    CFStringRef escaped = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)strIn, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", CFStringConvertNSStringEncodingToEncoding(encoding));
    NSString *strOut = [NSString stringWithString:(__bridge NSString *)escaped];
    CFRelease(escaped);
    return strOut;
}

+ (NSString *)formatDateStringToJapaneseFormat:(NSString *)dateStr{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)formatPriceToJapaneseFormat:(NSString *)oldPrice{
    NSString *newPrice = nil;
    NSNumber *price = @([oldPrice integerValue]);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"ja_JP"];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    newPrice = [formatter stringFromNumber:price];
    
    return newPrice;
}

@end
