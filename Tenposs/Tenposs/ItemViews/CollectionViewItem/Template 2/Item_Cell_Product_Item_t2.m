//
//  Item_Cell_Product_Item_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_Product_Item_t2.h"

@implementation Item_Cell_Product_Item_t2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setNeedsLayout];
    _thumb.clipsToBounds = YES;
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowRadius = 3;
}

- (void)configureCellWithData:(NSObject *)data{
    if (![data isKindOfClass:[ProductObject class]]) {
        return;
    }
    ProductObject *product = (ProductObject *)data;
    [_thumb sd_setImageWithURL:[NSURL URLWithString:product.image_url]];
    [_title setText:product.title];
    [_desc setText:product.desc];
    [_price setText:[NSString stringWithFormat:@"¥%@",product.price]];
}


+(CGFloat)getCellHeightWithWidth:(CGFloat)width{
    CGFloat imageHeight = width;
    CGFloat titleHeight = 16;
    CGFloat descHeight = 15;
    CGFloat priceHeight = 16;
    
    CGFloat height = imageHeight + 8 + titleHeight + 8 + descHeight+ 8 + priceHeight + 8;
    return height;
}


@end
