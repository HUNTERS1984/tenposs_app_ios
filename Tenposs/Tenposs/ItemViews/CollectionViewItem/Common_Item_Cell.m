//
//  Common_Item_Cell.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/5/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Common_Item_Cell.h"

@implementation Common_Item_Cell

- (void)configureCellWithData:(NSObject *)data{
    NSAssert(NO, @"Should be implemented by subclasses");
}

+(CGFloat)getCellHeightWithWidth:(CGFloat)width{
    NSAssert(NO, @"Should be implemented by subclasses");
    return 0;
}

@end
