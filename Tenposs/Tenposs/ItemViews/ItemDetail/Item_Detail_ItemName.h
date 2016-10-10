//
//  Item_Detail_ItemName.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/23/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item_Detail_Common.h"

@interface Item_Detail_ItemName : Item_Detail_Common

@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;
@property (weak, nonatomic) IBOutlet UILabel *ItemTitle;
@property (weak, nonatomic) IBOutlet UILabel *itemPrice;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;

@end
