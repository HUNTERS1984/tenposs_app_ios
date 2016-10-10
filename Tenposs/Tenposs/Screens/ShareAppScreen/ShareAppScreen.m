//
//  ShareAppScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/10/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "ShareAppScreen.h"
#import <FBSDKShareKit/FBSDKSharingContent.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>
#import <TwitterKit/TwitterKit.h>

@interface ShareAppScreen ()


@property (weak, nonatomic) IBOutlet UILabel *appId;
@property (weak, nonatomic) IBOutlet UIButton *buttonCopy;
@property (weak, nonatomic) IBOutlet UIButton *facebookShare;
@property (weak, nonatomic) IBOutlet UIButton *twitterShare;
@property (weak, nonatomic) IBOutlet UIButton *instagramShare;
@property (weak, nonatomic) IBOutlet UIButton *buttonSkip;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation ShareAppScreen

- (IBAction)shareButtonClicked:(id)sender{
    if(sender == _facebookShare){
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
        [FBSDKShareDialog showFromViewController:self
                                     withContent:content
                                        delegate:nil];
    }else if (sender == _twitterShare){
        TWTRComposer *composer = [[TWTRComposer alloc] init];
        
        [composer setURL:[NSURL URLWithString:@"https://developers.facebook.com"]];
        
        // Called from a UIViewController
        [composer showFromViewController:self completion:^(TWTRComposerResult result) {
            if (result == TWTRComposerResultCancelled) {
                NSLog(@"Tweet composition cancelled");
            }
            else {
                NSLog(@"Sending Tweet!");
            }
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self UISetup];
}

- (void)UISetup{
    
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    
    
    
    
}
- (IBAction)handleDismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

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
