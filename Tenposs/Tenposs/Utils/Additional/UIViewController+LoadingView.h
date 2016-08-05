//
//  UIViewController.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(LoadingView)

- (void)showLoadingViewWithMessage:(NSString *)message;
-(void) removeLoadingView;

@end
