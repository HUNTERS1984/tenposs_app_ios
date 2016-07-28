//
//  Const.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/28/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Const.h"

@implementation Const

#pragma CELL SPAN TYPE

+ (NSInteger)getNumberOfCellPerRowForCellSpanType:(CellSpanType)spanType{
    NSInteger numberOfSpan = 0;
    switch (spanType) {
        case CellSpanTypeSmall:
            numberOfSpan = 3;
            break;
        case CellSpanTypeNormal:
            numberOfSpan = 2;
            break;
        case CellSpanTypeLarge:
            numberOfSpan = 1;
            break;
        case CellSpanTypeFull:
            numberOfSpan = 1;
        default:
            break;
    }
    return numberOfSpan;
}

@end
