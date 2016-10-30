//
//  UIViewController.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+HandleBlock.h"
#import "UserData.h"
#import "LoginScreen.h"

@interface UIViewController(LoadingView)

- (void)showLoadingViewWithMessage:(NSString *)message;
-(void) removeLoadingView;

- (void)showErrorScreen:(NSString *)message;
-(void) removeErrorView;

- (void)showErrorScreen:(NSString *)message andRetryButton:(ActionBlock)handler;
-(void) removeErrorRetry;

- (void) removeAllInfoView;

@end
