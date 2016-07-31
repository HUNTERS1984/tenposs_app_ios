//
//  UIImage+Font.m
//  VideoFly
//
//  Created by ambient on 3/30/16.
//  Copyright © 2016 Content Net. All rights reserved.
//

#import "UIImage+Font.h"

@implementation UIImage(Font)
+(UIImage*)imageWithFont:(UIFont*) font identifier:(NSString*)identifier backgroundColor:(UIColor*)bgColor iconColor:(UIColor*)iconColor
{
    if (!bgColor) {
        bgColor = [UIColor clearColor];
    }
    if (!iconColor) {
        iconColor = [UIColor whiteColor];
    }
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName : font,
                                 NSForegroundColorAttributeName : iconColor,
                                 NSBackgroundColorAttributeName : bgColor,
                                 NSParagraphStyleAttributeName: style,
                                 };
    CGSize size = [identifier sizeWithAttributes:attributes];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //// Abstracted Attributes
    
    CGRect textRect = CGRectZero;
    textRect.size = size;
    
    //// Retangle Drawing
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:textRect];
    [bgColor setFill];
    [path fill];
    
    //// Text Drawing
    [iconColor setFill];
    
    [identifier drawInRect:textRect withAttributes:attributes];
    
    //Image returns
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
