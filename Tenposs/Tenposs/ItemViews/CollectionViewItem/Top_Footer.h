//
//  Top_Footer.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TopFooterTouchHandler)();

@interface Top_Footer : UICollectionReusableView

- (void)configureFooterWithTitle:(NSString *)title withTouchHandler:(TopFooterTouchHandler)handler;

+(CGFloat)height;

@end
