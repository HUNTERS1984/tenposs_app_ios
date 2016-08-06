//
//  MockupData.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MockupData : NSObject
+ (NSDictionary *)fetchDictionaryWithResourceName:(NSString *)name;
+ (NSData *)fetchDataWithResourceName:(NSString *)name;

@end
