//
//  ChatScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/12/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "ChatScreen.h"
#import "UserData.h"

@interface ChatScreen ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ChatScreen

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _webView.scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UserData *userdata = [UserData shareInstance];
    if ([userdata getToken] && [userdata getAppUserID]) {
        NSString *url = [NSString stringWithFormat:@"https://ten-po.com/chat/screen/%@" ,[userdata getAppUserID]];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
