//
//  ReserveScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/5/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "ReserveScreen.h"

@interface ReserveScreen ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ReserveScreen

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _webView.scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSString *)title{
    return @"Menu";
}

@end
