//
//  Item_Cell_Product.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/27/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_Product.h"
#import "UIUtils.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface Item_Cell_Product()
@property (weak, nonatomic) IBOutlet UIImageView *productThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;

@end

@implementation Item_Cell_Product

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(NSObject *)data{
    ProductObject *product = (ProductObject *)data;
    if (!product || ![product isKindOfClass:[ProductObject class]]) {
        return;
    }
    [_productName setText:product.title];
    [_productPrice setText:[NSString stringWithFormat:@"¥%@", product.price]];
    [_productThumbnail sd_setImageWithURL:[NSURL URLWithString:product.image_url]];
}

+ (CellSpanType)getCellSpanType{
    return CellSpanTypeNormal;
}

+ (CGFloat)getCellHeightWithWidth:(CGFloat)width{
    //Calculate cell height
    CGFloat imageHeight = width - 8;
    CGFloat titleHeight = 22;
    CGFloat priceHeight = 21;
    
    return imageHeight + 8 + titleHeight + 8 + priceHeight + 8;
}

@end
