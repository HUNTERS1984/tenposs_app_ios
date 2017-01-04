//
//  BaseViewController.h
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/13/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
-(void)invalidateCurrentUserSession;
-(void)showLogin;
- (void)showHomeScreen;
-(void)showAlertView:(NSString *)title message:(NSString *)message;
@end
