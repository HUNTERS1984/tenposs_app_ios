//
//  UIUtils.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SIZE_TYPE_MICRO             @"micro"
#define SIZE_TYPE_SMALL             @"small"
#define SIZE_TYPE_MEDIUM            @"medium"
#define SIZE_TYPE_LARGE             @"large"
#define SIZE_TYPE_EXTRA_LARGE       @"extra_large"

@interface UIUtils : NSObject
+(CGFloat)getLabelHeight:(UILabel*)label;
+ (UIStoryboard *)mainStoryboard;
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;
+ (CGFloat)getTextSizeWithType:(NSString *)sizeType;
@end
