//
//  Item_Cell_ShopInfo.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/27/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_ShopInfo.h"

@interface Item_Cell_ShopInfo()

@property (weak, nonatomic) IBOutlet UIView *shop_map;

@property (weak, nonatomic) IBOutlet UILabel *shopAddressText;
@property (weak, nonatomic) IBOutlet UIImageView *shopAddressIcon;

@property (weak, nonatomic) IBOutlet UILabel *shopOpenText;
@property (weak, nonatomic) IBOutlet UIImageView *shopOpenIcon;

@property (weak, nonatomic) IBOutlet UIImageView *shopPhoneIcon;
@property (weak, nonatomic) IBOutlet UILabel *shopPhoneText;

@end

@implementation Item_Cell_ShopInfo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)configureCellWithData:(NSObject *)data{
    
}

+ (CGFloat)cellHeightWithWidth:(CGFloat)width{
    //TODO: need implementation
    //MapView ratio is 2.5:1 , 3 info view with 60 each, button is 44 with 15 padding both top and bottom
    
    return 0.0f;
}

+(CellSpanType)getCellSpanType{
    return CellSpanTypeFull;
}

@end
