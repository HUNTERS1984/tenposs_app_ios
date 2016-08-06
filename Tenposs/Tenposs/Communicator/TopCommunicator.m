//
//  TopCommunicator.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/6/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TopCommunicator.h"

@implementation TopDataModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data.items":@"items",@"data.photos":@"photos",@"data.news":@"news",@"data.images":@"images"}];
}
@end

@implementation TopCommunicator

- (void)customPrepare:(Bundle *)params{
    
}

- (void)customProcess:(Bundle *)params{
    
}

@end
