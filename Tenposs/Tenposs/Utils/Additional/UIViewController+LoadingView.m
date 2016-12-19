//
//  UIViewController.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#define LOADING_VIEW_TAG 9843
#define ERROR_VIEW_TAG 9842
#define ERROR_RETRY_TAG 9841

#import "UIViewController+LoadingView.h"
#import "HexColors.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "AuthenticationManager.h"

@implementation UIViewController(LoadingView)

- (void)showLoadingViewWithMessage:(NSString *)message{
    UIView *loadingView = [[UIView alloc]initWithFrame:self.view.bounds];
    loadingView.backgroundColor = [UIColor whiteColor];
    loadingView.tag = LOADING_VIEW_TAG;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [loadingView addSubview:indicator];
    indicator.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerHor = [NSLayoutConstraint
                                     constraintWithItem:indicator
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:loadingView
                                     attribute:NSLayoutAttributeCenterX
                                     multiplier:1.0
                                     constant:0];
    NSLayoutConstraint *centerVer = [NSLayoutConstraint
                                     constraintWithItem:indicator
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:loadingView
                                     attribute:NSLayoutAttributeCenterY
                                     multiplier:1.0
                                     constant:0];
    [loadingView addConstraint:centerHor];
    [loadingView addConstraint:centerVer];
    [loadingView needsUpdateConstraints];
    [indicator startAnimating];
    
    [self.view addSubview:loadingView];
    loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                     constraintWithItem:loadingView
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                     attribute:NSLayoutAttributeLeading
                                     multiplier:1.0
                                     constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint
                                   constraintWithItem:loadingView
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeTrailing
                                   multiplier:1.0
                                   constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint
                                    constraintWithItem:loadingView
                                    attribute:NSLayoutAttributeBottom
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                    attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                    constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint
                                  constraintWithItem:loadingView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.view
                                  attribute:NSLayoutAttributeTop
                                  multiplier:1.0
                                  constant:0];
    
    NSArray *contraints = [NSArray arrayWithObjects:leading, trailing, bottom,top, nil];
    [self.view addConstraints:contraints];
    [self.view needsUpdateConstraints];
    [self removeAllInfoViewExcept:LOADING_VIEW_TAG];
}

- (void)showErrorScreen:(NSString *)message{
    UIView *errorView = [[UIView alloc]initWithFrame:self.view.bounds];
    errorView.backgroundColor = [UIColor whiteColor];
    errorView.tag = ERROR_VIEW_TAG;
    
    UILabel *errorMessage = [[UILabel alloc]init];
    [errorMessage setText:message];
    [errorMessage setFont:[UIFont systemFontOfSize:30]];
    [errorMessage setTextColor:[UIColor colorWithHexString:@"#d7d7d7"]];
    
    [errorView addSubview:errorMessage];
    
    errorMessage.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerHor = [NSLayoutConstraint
                                     constraintWithItem:errorMessage
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:errorView
                                     attribute:NSLayoutAttributeCenterX
                                     multiplier:1.0
                                     constant:0];
    NSLayoutConstraint *centerVer = [NSLayoutConstraint
                                     constraintWithItem:errorMessage
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:errorView
                                     attribute:NSLayoutAttributeCenterY
                                     multiplier:1.0
                                     constant:0];
    [errorView addConstraint:centerHor];
    [errorView addConstraint:centerVer];
    [errorView needsUpdateConstraints];
    
    [self.view addSubview:errorView];
    errorView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:errorView
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0
                                   constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint
                                    constraintWithItem:errorView
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0
                                    constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint
                                  constraintWithItem:errorView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.view
                                  attribute:NSLayoutAttributeBottom
                                  multiplier:1.0
                                  constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:errorView
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.view
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0
                               constant:0];
    
    NSArray *contraints = [NSArray arrayWithObjects:leading, trailing, bottom,top, nil];
    [self.view addConstraints:contraints];
    [self.view needsUpdateConstraints];
    [self removeAllInfoViewExcept:ERROR_VIEW_TAG];
}

- (void)showErrorScreen:(NSString *)message andRetryButton:(ActionBlock)handler{
    UIView *errorView = [[UIView alloc]initWithFrame:self.view.bounds];
    errorView.backgroundColor = [UIColor whiteColor];
    errorView.tag = ERROR_RETRY_TAG;
    
    UILabel *errorMessage = [[UILabel alloc]init];
    [errorMessage setText:message];
    [errorMessage setFont:[UIFont systemFontOfSize:30]];
    [errorMessage setTextColor:[UIColor colorWithHexString:@"#d7d7d7"]];
    
    [errorView addSubview:errorMessage];
    
    errorMessage.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerHor = [NSLayoutConstraint
                                     constraintWithItem:errorMessage
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:errorView
                                     attribute:NSLayoutAttributeCenterX
                                     multiplier:1.0
                                     constant:0];
    NSLayoutConstraint *centerVer = [NSLayoutConstraint
                                     constraintWithItem:errorMessage
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:errorView
                                     attribute:NSLayoutAttributeCenterY
                                     multiplier:1.0
                                     constant:0];
    [errorView addConstraint:centerHor];
    [errorView addConstraint:centerVer];
    [errorView needsUpdateConstraints];
    
    UIButton *retry = [UIButton buttonWithType:UIButtonTypeCustom];
    [retry setTitle:NSLocalizedString(@"retry_button", nil) forState:UIControlStateNormal];
    [retry setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    retry.backgroundColor = [UIColor colorWithHexString:@"1FBFBD"];
    [retry handleControlEvent:UIControlEventTouchUpInside withBlock:handler];
    
    [errorView addSubview:retry];
    
    retry.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *retryHor = [NSLayoutConstraint
                                     constraintWithItem:retry
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:errorView
                                     attribute:NSLayoutAttributeCenterX
                                     multiplier:1.0
                                     constant:0];
    NSLayoutConstraint *centerTop = [NSLayoutConstraint
                                     constraintWithItem:retry
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:errorMessage
                                     attribute:NSLayoutAttributeBottom
                                     multiplier:1.0
                                     constant:8];
    [errorView addConstraint:retryHor];
    [errorView addConstraint:centerTop];
    [errorView needsUpdateConstraints];
    
    [self.view addSubview:errorView];
    errorView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:errorView
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0
                                   constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint
                                    constraintWithItem:errorView
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0
                                    constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint
                                  constraintWithItem:errorView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.view
                                  attribute:NSLayoutAttributeBottom
                                  multiplier:1.0
                                  constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:errorView
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.view
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0
                               constant:0];
    
    NSArray *contraints = [NSArray arrayWithObjects:leading, trailing, bottom,top, nil];
    [self.view addConstraints:contraints];
    [self.view needsUpdateConstraints];
    
    [self removeAllInfoViewExcept:ERROR_RETRY_TAG];
}

-(void) removeLoadingView{
    for (UIView *subView in self.view.subviews) {
        if (subView.tag == LOADING_VIEW_TAG) {
            [subView removeFromSuperview];
            return;
        }
    }
}

-(void) removeErrorView{
    for (UIView *subView in self.view.subviews) {
        if (subView.tag == ERROR_VIEW_TAG) {
            [subView removeFromSuperview];
            return;
        }
    }
}

-(void) removeErrorRetry{
    for (UIView *subView in self.view.subviews) {
        if (subView.tag == ERROR_RETRY_TAG) {
            [subView removeFromSuperview];
            return;
        }
    }
}

- (void) removeAllInfoView{
    for (UIView *subView in self.view.subviews) {
        if (subView.tag == ERROR_RETRY_TAG
            || subView.tag == ERROR_VIEW_TAG
            || subView.tag == LOADING_VIEW_TAG) {
            [subView removeFromSuperview];
            return;
        }
    }
}

- (void)removeAllInfoViewExcept:(NSInteger)tag{
    for (UIView *subView in self.view.subviews) {
        if (subView.tag == ERROR_RETRY_TAG
            || subView.tag == ERROR_VIEW_TAG
            || subView.tag == LOADING_VIEW_TAG) {
            if (subView.tag == tag) {
                return;
            }else{
                [subView removeFromSuperview];
                return;
            }
        }
    }
}

-(BOOL)signOut{
    if ([[UserData shareInstance]getToken]) {
        [SVProgressHUD show];
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:[[UserData shareInstance]getToken] forKey:KeyAPI_TOKEN];
        __weak UIViewController *weakSelf = self;
        [[AuthenticationManager sharedInstance] AuthLogOutWithCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
            [SVProgressHUD dismiss];
            [weakSelf invalidateCurrentUserSession];
        }];
        return YES;
    }
    
    return NO;
}

-(void)showLogin{
    UIViewController *login = [GlobalMapping getLoginScreenWithNavigation];
    [self presentViewController:login animated:YES completion:nil];
}

- (void)invalidateCurrentUserSession{
    UserData *userData = [UserData shareInstance];
    [userData invalidateCurrentUser];
    [self showLogin];
}

- (BOOL)checkForInternetConnectionWithRetryHandler:(ActionBlock)handler{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        //connection unavailable
        [self showErrorScreen:NSLocalizedString(@"no_internet_connection", nil) andRetryButton:handler];
        return NO;
    }else{
        //connection available
        return YES;
    }
}

- (BOOL)checkForInternetConnection{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        //connection unavailable
        return NO;
    }else{
        //connection available
        return YES;
    }
}

@end
