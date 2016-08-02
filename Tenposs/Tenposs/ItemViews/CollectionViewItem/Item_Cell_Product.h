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

@interface Item_Cell_Product : UICollectionViewCell

+(CellSpanType)getCellSpanType;

-(void)configureCellWithData:(ProductObject *)product;

@end
