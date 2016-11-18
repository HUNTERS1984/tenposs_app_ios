//
//  Item_Cell_Product.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/27/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Const.h"
#import "DataModel.h"
#import "Common_Item_Cell.h"

@interface Item_Cell_Product : Common_Item_Cell

@property (weak, nonatomic) IBOutlet UIImageView *productThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;

@end
