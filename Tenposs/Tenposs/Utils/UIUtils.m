//
//  UIUtils.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "UIUtils.h"

@implementation UIUtils

+(CGFloat)getLabelHeight:(UILabel*)label{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

+ (UIStoryboard *)mainStoryboard{
    UIStoryboard *mainStoryboard = nil;
    mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    return mainStoryboard;
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    CGSize actSize = image.size;
    float scale = actSize.width/actSize.height;
    
    if (scale < 1) {
        newSize.height = newSize.width/scale;
    } else {
        newSize.width = newSize.height*scale;
    }
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (CGFloat)getTextSizeWithType:(NSString *)sizeType{
    if ([sizeType isEqualToString:SIZE_TYPE_MICRO]) {
        return 11;
    }else if ([sizeType isEqualToString:SIZE_TYPE_SMALL]) {
        return 13;
    }else if ([sizeType isEqualToString:SIZE_TYPE_MEDIUM]) {
        return 15;
    }else if ([sizeType isEqualToString:SIZE_TYPE_LARGE]) {
        return 17;
    }else if ([sizeType isEqualToString:SIZE_TYPE_EXTRA_LARGE]) {
        return 19;
    }else{
        return 15;
    }
}

@end
