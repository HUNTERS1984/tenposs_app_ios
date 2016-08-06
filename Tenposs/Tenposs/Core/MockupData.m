//
//  MockupData.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "MockupData.h"

@implementation MockupData

+ (NSDictionary *)fetchDictionaryWithResourceName:(NSString *)name{
    NSURL *resourceURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"json"];
    if (!resourceURL) {
        NSAssert(NO, @"Could not find resource: %@", name);
    }
    NSError *error;
    NSData *jsonData = [NSData dataWithContentsOfURL:resourceURL options:NSDataReadingMappedIfSafe error:&error];
    if(!jsonData){
        return nil;
    }
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    return data;
}

+ (NSData *)fetchDataWithResourceName:(NSString *)name{
    NSURL *resourceURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"json"];
    if (!resourceURL) {
        NSAssert(NO, @"Could not find resource: %@", name);
    }
    NSError *error;
    NSData *jsonData = [NSData dataWithContentsOfURL:resourceURL options:NSDataReadingMappedIfSafe error:&error];
    return jsonData;
}


@end
