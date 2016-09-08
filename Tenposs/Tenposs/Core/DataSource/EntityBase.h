//
//  EntityBase.h
//  Bireki
//
//  Created by Takaaki Kakinuma on 2014/06/19.
//  Copyright (c) 2014年 piped bits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntityBase : NSObject

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (void)attributes2obj:(NSDictionary *)attributes;
- (id)null2nil:(id)attribute;


-(BOOL)original:(NSString *)originalString didContaintString:(NSString *)stringContained;
-(NSString *)stringDateFromNSDate:(NSDate *)date;

-(id)copy;

-(BOOL)compareToObjects:(id)object;

@end
