//
//  Item_Detail_Item_Size.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/5/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Detail_Item_Size.h"

@implementation Item_Detail_Item_Size

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(NSObject *)data{
    if ([data isKindOfClass:[ProductSizeObject class]]) {
        [_title setText:((ProductSizeObject *)data).value];
    }else if ([data isKindOfClass:[NSString class]]){
        [_title setText:(NSString *)data];
    }
}

+ (CGFloat)getCellHeightWithWidth:(CGFloat)width{
    return 30;
}

@end
