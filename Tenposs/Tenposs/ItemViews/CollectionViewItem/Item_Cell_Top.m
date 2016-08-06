//
//  Item_Cell_Top.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_Top.h"

@implementation Item_Cell_Top

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(NSObject *)data{

}

+ (CellSpanType)getCellSpanType{
    return CellSpanTypeLarge;
}

+ (CGFloat)getCellHeightWithWidth:(CGFloat)width{
    return width / 2;
}

@end
