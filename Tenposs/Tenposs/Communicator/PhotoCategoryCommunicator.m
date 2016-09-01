//
//  PhotoCategoryCommunicator.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/31/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "PhotoCategoryCommunicator.h"


@implementation PhotoCategoryListModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data.photo_categories":@"items"}];
}

@end

@implementation PhotoCategoryCommunicator

@end
