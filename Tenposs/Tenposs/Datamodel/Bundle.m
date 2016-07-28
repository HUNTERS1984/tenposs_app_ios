//
//  Bundle.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/28/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Bundle.h"

@implementation Bundle
-(id) init
{
    self = [super init];
    dictionary = [[NSMutableDictionary alloc] init];
    return  self;
}
-(id)           put:(NSString*) key value:(id) value
{
    [dictionary setObject:value forKey:key];
    return self;
}
-(void)         clear;
{
    [dictionary removeAllObjects];
}
-(BOOL)         getBoolean:(NSString*) key
{
    return [[dictionary objectForKey:key] boolValue];
}
-(id)           get:(NSString*) key
{
    return [dictionary objectForKey:key];
}
-(NSInteger)    getInt:(NSString*) key
{
    return [[dictionary objectForKey:key] integerValue];
}
-(long)    getLong:(NSString*) key
{
    return [[dictionary objectForKey:key] longValue];
}
-(long long )    getLongLong:(NSString*) key
{
    return [[dictionary objectForKey:key] longLongValue];
}

-(double)       getDouble:(NSString*) key
{
    return [[dictionary objectForKey:key] doubleValue];
}


@end
