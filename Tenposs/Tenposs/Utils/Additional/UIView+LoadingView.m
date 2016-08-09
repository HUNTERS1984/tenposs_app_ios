//
//  UIView+LoadingView.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#define LOADING_VIEW_VIEW_TAG   9844

#import "UIView+LoadingView.h"

@implementation UIView(LoadingView)

- (void)showLoadingView{
    UIView *loadingView = [[UIView alloc]initWithFrame:self.bounds];
    loadingView.backgroundColor = [UIColor whiteColor];
    loadingView.tag = LOADING_VIEW_VIEW_TAG;
    
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
    
    [self addSubview:loadingView];
    loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:loadingView
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0
                                   constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint
                                    constraintWithItem:loadingView
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0
                                    constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint
                                  constraintWithItem:loadingView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self
                                  attribute:NSLayoutAttributeBottom
                                  multiplier:1.0
                                  constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:loadingView
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:self
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0
                               constant:0];
    
    NSArray *contraints = [NSArray arrayWithObjects:leading, trailing, bottom,top, nil];
    [self addConstraints:contraints];
    
    [self needsUpdateConstraints];

}

- (void)removeLoadingView{
    for (UIView *subView in self.subviews) {
        if (subView.tag == LOADING_VIEW_VIEW_TAG) {
            [subView removeFromSuperview];
            return;
        }
    }
}

@end
