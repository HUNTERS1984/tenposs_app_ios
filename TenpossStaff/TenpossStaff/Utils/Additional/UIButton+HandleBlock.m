//
//  UIButton+HandleBlock.m
//  VideoFly
//
//  Created by ambient on 10/1/16.
//  Copyright (c) 2016 Content Net. All rights reserved.
//

#import "UIButton+HandleBlock.h"
#import <objc/runtime.h>


@implementation UIButton (HandleBlock)
- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block {
    objc_setAssociatedObject(self, &UIButtonBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}


- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &UIButtonBlockKey);
    if (block) {
        block();
    }
}

@end
