//
//  Item_Detail_ItemName.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/23/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Detail_ItemName.h"
#import "DataModel.h"

#define CATEGORY_HEIGHT_phone 20
#define TITLE_HEIGHT_phone 22
#define PRICE_HEIGHT_phone 22
#define BUTTON_HEIGHT_phone 40

#define SMALL_PADDING 8
#define LARGE_PADDING 16

@interface Item_Detail_ItemName()
@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;
@property (weak, nonatomic) IBOutlet UILabel *ItemTitle;
@property (weak, nonatomic) IBOutlet UILabel *itemPrice;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@end

@implementation Item_Detail_ItemName

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(NSObject *)data{
    if ([data isKindOfClass:[ProductObject class]]) {
        ProductObject *item = (ProductObject *) data;
        
        [self.categoryTitle setText:item.parentCategory.categoryName];
        [self.ItemTitle setText: [item.title uppercaseString]];
        [self.itemPrice setText:item.price];
        
    }else {
        return;
    }
}
+ (CGFloat)getCellHeightWithWidth:(CGFloat)width{
    
    CGFloat cellHeight = 0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        cellHeight = SMALL_PADDING + CATEGORY_HEIGHT_phone + SMALL_PADDING + TITLE_HEIGHT_phone + LARGE_PADDING +LARGE_PADDING + LARGE_PADDING + BUTTON_HEIGHT_phone + LARGE_PADDING + LARGE_PADDING;
    }else {
        //TODO: need height for iPad
    }
    return cellHeight;
}
@end
