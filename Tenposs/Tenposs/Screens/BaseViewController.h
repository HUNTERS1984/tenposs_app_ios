//
//  BaseViewController.h
//  Tenposs
//
//  Created by Luong Hong Quan on 9/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

#pragma mark - Keyboard Notifications
- (void) subscribeForKeyboardWillShowNotificationUsingBlock:(void (^)(NSNotification *note))block;
- (void) subscribeForKeyboardWillChangeFrameNotificationUsingBlock:(void (^)(NSNotification *note))block;
- (void) subscribeForKeyboardWillHideNotificationUsingBlock:(void (^)(NSNotification *note))block;
- (void) subscribeForKeyboardDidShowNotificationUsingBlock:(void (^)(NSNotification *note))block;
- (void) subscribeForKeyboardDidHideNotificationUsingBlock:(void (^)(NSNotification *note))block;
- (void) subscribeForKeyboardDidChangeFrameNotificationUsingBlock:(void (^)(NSNotification *note))block;

- (void) unsubscribeForKeyboardWillShowNotification;
- (void) unsubscribeForKeyboardDidShowNotification;
- (void) unsubscribeForKeyboardWillChangeFrameNotification;
- (void) unsubscribeForKeyboardWillHideNotification;
- (void) unsubscribeForKeyboardDidHideNotification;

- (void) showLoadingView;
- (void) hideLoadingView;
- (void) showSuccess:(NSString*)str;
- (void) showError:(NSString*)str;

-(void)showAlertView:(NSString *)title message:(NSString *)message;
-(void)logOutBecauseInvalidToken;
-(void)showLogin;
-(void)showTop;
-(BOOL)signOut;
@end
