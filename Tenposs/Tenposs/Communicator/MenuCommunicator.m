//
//  MenuCommunicator.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "MenuCommunicator.h"

@implementation MenuCategoryModel

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
    [self.items addObject:product];
}

@end

@implementation MenuCommunicator

- (void)customPrepare:(Bundle *)params{
    
}

- (void)customProcess:(Bundle *)params{
    
}

@end
