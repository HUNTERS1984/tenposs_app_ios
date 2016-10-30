//
//  OAuthScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/13/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "OAuthScreen.h"
#import <InAppSettingsKit/IASKSettingsReader.h>
#import "Const.h"
#import "NetworkCommunicator.h"


static NSString *const authUrlString = @"https://api.instagram.com/oauth/authorize/";
static NSString *const tokenUrlString = @"https://api.instagram.com/oauth/access_token/";

// ADD YOUR CLIENT ID AND SECRET HERE
static NSString *const clientID = @"8a2eb09ac42d4ad3bdbd61b3c6742a33";
static NSString *const clientSecret = @"586b1c5041134bc7946894b8da702f4b";

// YOU NEED A BAD URL HERE - THIS NEEDS TO MATCH YOUR URL SET UP FOR YOUR
// INSTAGRAM APP
static NSString *const redirectUri = @"http://tinhotplus.net/access_insta/";

// CHANGE TO THE SCOPE YOU NEED ACCESS TO
static NSString *const scope = @"basic";

@interface OAuthScreen ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation OAuthScreen

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _webView.scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *fullAuthUrlString = [[NSString alloc]
                                   initWithFormat:@"%@?client_id=%@&redirect_uri=%@&scope=%@&response_type=token&display=touch",
                                   authUrlString,
                                   clientID,
                                   redirectUri,
                                   scope
                                   ];
    NSURL *authUrl = [NSURL URLWithString:fullAuthUrlString];
    NSURLRequest *myRequest = [[NSURLRequest alloc] initWithURL:authUrl];
    _webView.delegate = self;
    [_webView loadRequest:myRequest];
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

#pragma mark - UIWebViewDelegate

// GRAB THE URL TRAFFIC TO CATCH THE ACCESS TOKEN OUT OF THE RETURN URL
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *Url = [request URL];
    NSLog(@"INSTA_URL = %@",[Url absoluteString]);
    NSArray *UrlParts = [Url pathComponents];
    if ([[UrlParts objectAtIndex:(1)] isEqualToString:@"access_insta"]) {
        // CONVERT TO STRING AN CLEAN
        NSString *urlResources = [Url resourceSpecifier];
        urlResources = [urlResources stringByReplacingOccurrencesOfString:@"?" withString:@""];
        urlResources = [urlResources stringByReplacingOccurrencesOfString:@"#" withString:@""];
        
        // SEPORATE OUT THE URL ON THE /
        NSArray *urlResourcesArray = [urlResources componentsSeparatedByString:@"/"];
        
        // THE LAST OBJECT IN THE ARRAY
        NSString *urlParamaters = [urlResourcesArray objectAtIndex:([urlResourcesArray count]-1)];
        
        // SEPORATE OUT THE URL ON THE &
        NSArray *urlParamatersArray = [urlParamaters componentsSeparatedByString:@"&"];
        if([urlParamatersArray count] == 1) {
            NSString *keyValue = [urlParamatersArray objectAtIndex:(0)];
            NSArray *keyValueArray = [keyValue componentsSeparatedByString:@"="];
            
            if([[keyValueArray objectAtIndex:(0)] isEqualToString:@"access_token"]) {
                
                NSMutableDictionary *socialProfile = [NSMutableDictionary new];
                
                NSString *access_token =[keyValueArray objectAtIndex:(1)];
                
                [socialProfile setObject:@"3" forKey:KeyAPI_SOCIAL_TYPE];
                
                if (access_token && ![access_token isEqualToString:@""]) {
                    [socialProfile setObject:access_token forKey:KeyAPI_SOCIAL_TOKEN];
                }
                
                NSArray *accessComp = [access_token componentsSeparatedByString:@"."];
                
                NSString *userId = [accessComp firstObject];
                
                if(userId && ![userId isEqualToString:@""]){
                    
                    [socialProfile setObject:userId forKey:KeyAPI_SOCIAL_ID];
                    
                    // Send a synchronous request
                    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/?access_token=%@",userId,access_token]]];
                    NSURLResponse * response = nil;
                    NSError * error = nil;
                    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                                          returningResponse:&response
                                                                      error:&error];
                    
                    NSError *jsonError;
                    if (error == nil){
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:NSJSONReadingMutableContainers
                                                                                error:&jsonError];
                        if (!jsonError) {
                            NSString *nickname = [[json objectForKey:@"data"] objectForKey:@"username"];
                            if (nickname) {
                                [socialProfile setObject:nickname forKey:KeyAPI_NICKNAME];
                            }
                        }else{
                            //TODO: handle json parse error
                        }
                    }else{
                        //TODO: handle request error
                    }
                }
                
                [socialProfile setObject:@"" forKey:KeyAPI_SOCIAL_SECRET];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SETTINGS_KeyUserInstaAccessToken:socialProfile}];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            // THERE WAS AN ERROR
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SETTINGS_KeyUserInstaAccessToken:@""}];
            [self.navigationController popViewControllerAnimated:YES];
        }
        return NO;
    }
    return YES;
}

// ACTIVITY INDICATOR
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [_activityIndicator setHidden:NO];
    [_activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_activityIndicator stopAnimating];
    [_activityIndicator setHidden:YES];
}

@end
