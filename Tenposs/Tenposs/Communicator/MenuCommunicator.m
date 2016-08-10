//
//  MenuCommunicator.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "MenuCommunicator.h"

@implementation MenuListModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data":@"items"}];
}

@end

@implementation MenuCategoryModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data.items":@"items"}];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.items = (NSMutableArray<ProductObject> *)[[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addProduct:(ProductObject *)product{
    if (!self.items) {
        self.items = (NSMutableArray<ProductObject> *)[[NSMutableArray alloc] init];
    }
    for (ProductObject *item in self.items) {
        if (item.product_id == product.product_id) {
            [item updateItemWithItem:product];
            return;
        }
    }
    [self.items addObject:product];
}

@end

@implementation MenuCommunicator

- (void)customPrepare:(Bundle *)params{
    
}

- (void)customProcess:(Bundle *)params{
    
}

@end
