//
//  Item_Detail_ItemName_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/9/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Detail_ItemName_t2.h"
#import "Utils.h"

@implementation Item_Detail_ItemName_t2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(NSObject *)data{
    if (![data isKindOfClass:[ProductObject class]]) {
        return;
    }
    ProductObject *item = (ProductObject *)data;
    if (item) {
        [_title setText:item.title];
        [_categoryName setText:item.menu_name];
        [_price setText:[NSString stringWithFormat:@"%@",[Utils formatPriceToJapaneseFormat:item.price]]];
    }
}


+ (CGFloat)getCellHeightWithWidth:(CGFloat)width{
    CGFloat height = 0;
    
    CGFloat titleHeight = 24;
    CGFloat descriptionHeight = 21;
    height = 8 + titleHeight + 8 + descriptionHeight + 8;
    return height;
}

@end
