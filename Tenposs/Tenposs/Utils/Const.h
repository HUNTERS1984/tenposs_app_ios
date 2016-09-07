//
//  Const.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/28/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_ID  @"2a33ba4ea5c9d70f9eb22903ad1fb8b2"
#define APP_SECRET  @"33d3afaeefdffe55b185359f901d15e4"

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
