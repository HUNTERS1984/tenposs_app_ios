//
//  DashedLineView.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/11/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface DashedLineView : UIView

/**
 * The lenght of one dash
 */
@property (nonatomic,assign) IBInspectable CGFloat dashHeight;

/**
 * The width of one dash
 */
@property (nonatomic,assign) IBInspectable CGFloat dashWidth;

/**
 * The length between two dashes
 */
@property (nonatomic,assign) IBInspectable CGFloat spaceLenght;

/**
 * The color of the line
 */
@property (nonatomic,strong) IBInspectable UIColor   *lineColor;

@end
