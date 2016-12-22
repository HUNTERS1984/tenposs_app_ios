//
//  UserPrivacyScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/11/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "UserPrivacyScreen.h"
#import "AppConfiguration.h"
#import "UIViewController+LoadingView.h"
#import "HexColors.h"

@interface UserPrivacyScreen ()
@property(strong, nonatomic) UIWebView *webView;
@property(strong, nonatomic) NSURL *url;
@end

@implementation UserPrivacyScreen

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self showLoadingViewWithMessage:@""];
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *appSettings = [appConfig getAvailableAppSettings];
    
    if (appSettings.company_info && ![appSettings.company_info isEqualToString:@""]) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_webView];
        [_webView loadHTMLString:appSettings.user_privacy baseURL:nil];
    }else{
        [self showErrorScreen:NSLocalizedString(@"NO CONTENT",nil)];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor colorWithHexString:appSettings.title_color], NSForegroundColorAttributeName,nil]];
}

- (NSString *)title{
    return @"採用情報";
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
