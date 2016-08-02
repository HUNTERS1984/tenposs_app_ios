//
//  Item_Cell_Product.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/27/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_Product.h"

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

-(void)configureCellWithData:(ProductObject *)product{
    
    [_productName setText:product.title];
    [_productPrice setText:product.price];
    
}

+(CellSpanType)getCellSpanType{
    return CellSpanTypeNormal;
}

@end
