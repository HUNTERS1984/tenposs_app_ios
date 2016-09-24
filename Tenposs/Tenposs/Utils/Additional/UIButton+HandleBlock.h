//
//  UIButton+HandleBlock.h
//  VideoFly
//
//  Created by ambient on 1/8/16.
//  Copyright © 2016 Content Net. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void (^ActionBlock)(UIButton *button, NSString* url);
typedef void (^ActionBlock)();//(UIButton *button, NSString* url);

static char UIButtonBlockKey;

@interface UIButton (HandleBlock)
- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block;
- (void)callActionBlock:(id)sender;
@end
