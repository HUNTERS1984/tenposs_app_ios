//
//  UIFont+Themify.h
//  VideoFly
//
//  Created by ambient on 3/30/16.
//  Copyright © 2016 Content Net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont(Themify)
+ (UIFont*)themifyFontOfSize:(CGFloat)size;
+ (NSString*)stringForThemifyIdentifier:(NSString*)identifier;

@end
