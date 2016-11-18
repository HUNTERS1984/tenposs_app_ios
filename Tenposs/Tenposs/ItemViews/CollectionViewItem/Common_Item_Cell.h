//
//  Common_Item_Cell.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/5/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Const.h"
#import "DataModel.h"
#import "UIImageView+WebCache.h"

@interface Common_Item_Cell : UICollectionViewCell

- (void)configureCellWithData:(NSObject *)data;

+(CGFloat)getCellHeightWithWidth:(CGFloat)width;

@end
