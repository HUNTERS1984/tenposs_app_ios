//
//  CompanyInfoScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/11/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "CompanyInfoScreen.h"
#import "AppConfiguration.h"
#import "UIViewController+LoadingView.h"

@interface CompanyInfoScreen ()
@property(strong, nonatomic) UIWebView *webView;
@property(strong, nonatomic) NSURL *url;
@end

@implementation CompanyInfoScreen

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self showLoadingViewWithMessage:@""];
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *appSettings = [appConfig getAvailableAppSettings];
    
    if (appSettings.company_info && ![appSettings.company_info isEqualToString:@""]) {
        _url = [NSURL URLWithString:appSettings.company_info];
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_webView];
    }else{
        [self showErrorScreen:NSLocalizedString(@"NO CONTENT",nil)];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(_webView){
        [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
        [self removeAllInfoView];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
