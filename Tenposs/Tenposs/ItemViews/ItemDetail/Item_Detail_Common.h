//
//  Item_Detail_Common.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Item_Detail_Common : UICollectionViewCell

- (void)configureCellWithData:(NSObject *)data;

+ (CGFloat)getCellHeightWithWidth:(CGFloat)width;

@end
