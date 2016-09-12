//
//  NewsCommunicator.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/12/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "NewsCommunicator.h"

@implementation NewsCategoryResponse
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data":@"items"}];
}
@end

@implementation NewsCommunicator



@end
