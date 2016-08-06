//
//  Const.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/28/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>

///CellSpanType to define how much space a cell should takes
typedef NS_ENUM(NSInteger, CellSpanType) {
    CellSpanTypeSmall,
    CellSpanTypeNormal,
    CellSpanTypeLarge,
    CellSpanTypeFull,
    CellSpanTypeNone,
};

@interface Const : NSObject

+ (NSInteger)getNumberOfCellPerRowForCellSpanType:(CellSpanType)spanType;

@end
