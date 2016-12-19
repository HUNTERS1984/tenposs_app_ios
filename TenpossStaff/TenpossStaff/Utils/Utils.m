//
//  Utils.m
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/13/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (UIStoryboard *)mainStoryboard{
    UIStoryboard *mainStoryboard = nil;
    mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    return mainStoryboard;
}

+ (NSString *)getSigWithStrings:(NSArray <NSString *> *)stringArray{
    NSString *sig = @"";
    for (NSString *string in stringArray) {
        sig = [sig stringByAppendingString:string];
    }
    return [Utils hashed_string:sig];
}

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


+ (NSString *)relativeDateStringForDate:(NSDate *)date{
    
    if (!date) {
        return @"";
    }
    
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
    NSCalendarUnitMonth | NSCalendarUnitYear;
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:date
                                                                     toDate:[NSDate date]
                                                                    options:0];
    if (components.year > 0) {
        return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
    } else if (components.month > 0) {
        return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
    } else if (components.weekOfYear > 0) {
        return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
    } else if (components.day > 0) {
        if (components.day > 1) {
            return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
        } else {
            return @"Yesterday";
        }
    }else if (components.hour > 0){
        if (components.hour > 1) {
            return [NSString stringWithFormat:@"%ld hours ago", (long)components.day];
        } else {
            return @"an hour ago";
        }
    }else if (components.minute > 0){
        if (components.minute > 1) {
            return [NSString stringWithFormat:@"%ld minutes ago", (long)components.day];
        } else {
            return @"a minute ago";
        }
    }else if(components.second > 0){
        if (components.second > 30) {
            return [NSString stringWithFormat:@"%ld seconds ago", (long)components.day];
        } else {
            return @"just now";
        }
    }else{
        return @"";
    }
}

+ (NSDate *)convertDateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateString];
    return date;
}


+ (long long)currentTimeInMillis{
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    return milliseconds;
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

@end
