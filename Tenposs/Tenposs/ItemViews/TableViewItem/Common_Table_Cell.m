//
//  Common_Table_Cell.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Common_Table_Cell.h"

@implementation Common_Table_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(NSObject *)data{
    NSAssert(NO, @"Should be implemented by subclasses");
    return;
}

+ (CGFloat)getHeightWithWidth:(CGFloat)width{
    NSAssert(NO, @"Should be implemented by subclasses");
    return 0;
}

@end
