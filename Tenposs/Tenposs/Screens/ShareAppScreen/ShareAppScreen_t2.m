//
//  ShareAppScreen_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/15/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "ShareAppScreen_t2.h"
#import "HexColors.h"
#import <FBSDKShareKit/FBSDKSharingContent.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>
#import <TwitterKit/TwitterKit.h>

@interface ShareAppScreen_t2 ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *dimBackground;
@property (weak, nonatomic) IBOutlet UILabel *shareTitle;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *instagramButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation ShareAppScreen_t2

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.view setNeedsLayout];
    
    _contentView.layer.cornerRadius = 5;
    _contentView.clipsToBounds = YES;
    
    _closeButton.layer.cornerRadius = 5;
    _closeButton.layer.borderWidth = 1;
    _closeButton.layer.borderColor = [UIColor colorWithHexString:@"3CB963"].CGColor;
    
}
- (IBAction)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)facebookTapped:(id)sender {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:nil];

}
- (IBAction)twitterTapped:(id)sender {
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
- (IBAction)instagramTapp:(id)sender {
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }else {
        NSLog (@"Instagram not found");
    }
}
- (IBAction)emailTapped:(id)sender {
    //TODO: send email
}

- (IBAction)handleDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.code.text = self.share_code;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
