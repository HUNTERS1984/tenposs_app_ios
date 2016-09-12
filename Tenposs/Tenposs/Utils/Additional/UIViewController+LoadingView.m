//
//  UIViewController.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#define LOADING_VIEW_TAG 9843
#define ERROR_VIEW_TAG 9842

#import "UIViewController+LoadingView.h"
#import "HexColors.h"

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
    
    [self removeErrorView];
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
    
    [self removeLoadingView];

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

@end
