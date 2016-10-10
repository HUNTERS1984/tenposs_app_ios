//
//  ReserveScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/5/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "ReserveScreen.h"
#import "AppConfiguration.h"
#import "UIViewController+LoadingView.h"
#import "ReserveCommunicator.h"
#import "Const.h"
#import "Utils.h"

@interface ReserveScreen ()<TenpossCommunicatorDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ReserveScreen

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _webView.scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showLoadingViewWithMessage:@""];
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *appSettings = [appConfig getAvailableAppSettings];
    
    ReserveCommunicator *request = [ReserveCommunicator new];
    Bundle *params = [Bundle new];
    [params put:KeyAPI_APP_ID value:APP_ID];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    [params put:KeyAPI_TIME value:currentTime];
    [params put:KeyAPI_STORE_ID value:[appConfig getStoreId]];
    NSArray *strings = [NSArray arrayWithObjects:APP_ID,currentTime,[appConfig getStoreId],APP_SECRET,nil];
    [params put:KeyAPI_SIG value:[Utils getSigWithStrings:strings]];
    [request execute:params withDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)loadReservePage:(NSString *)url{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self removeAllInfoView];
}

- (NSString *)title{
    return @"予約";
}

#pragma mark - TenpossCommunicatorDelegate

- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
    NSError *error = nil;
    if (errorCode != ERROR_OK) {
        NSString *errorDomain = [responseParams get:KeyResponseError];
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
    }else{
        ReserveResponse *data = (ReserveResponse *)[responseParams get:KeyResponseObject];
        if (data && data.reserve && [data.reserve count] > 0 &&[data.reserve firstObject]) {
            ReserveObject *res = [data.reserve firstObject];
            if(res)
            [self loadReservePage:res.reserve_url];
        }
    }
}
- (void)begin:(TenpossCommunicator*)request data:(Bundle*) responseParams{}
-( void)cancelAllRequest{}

@end
