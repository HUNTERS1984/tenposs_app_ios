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

@interface ShareAppScreen () <UIDocumentInteractionControllerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *appId;
@property (weak, nonatomic) IBOutlet UIButton *buttonCopy;
@property (weak, nonatomic) IBOutlet UIButton *facebookShare;
@property (weak, nonatomic) IBOutlet UIButton *twitterShare;
@property (weak, nonatomic) IBOutlet UIButton *instagramShare;
@property (weak, nonatomic) IBOutlet UIButton *buttonSkip;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (strong, nonatomic) UIDocumentInteractionController *documentController;

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
    }else if(sender == _instagramShare){
        NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
        
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
            
//            //convert image into .png format.
//            NSData *imageData = UIImagePNGRepresentation(image);
//            
//            //create instance of NSFileManager
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            
//            //create an array and store result of our search for the documents directory in it
//            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            
//            //create NSString object, that holds our exact path to the documents directory
//            NSString *documentsDirectory = [paths objectAtIndex:0];
//            
//            //add our image to the path
//            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"insta.igo"]];
//            
//            //finally save the path (image)
//            [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
            
            //CGRect rect = CGRectMake(0 ,0 , 0, 0);

            //            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
//            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//            UIGraphicsEndImageContext();
//            
//            NSString *fileNameToSave = [NSString stringWithFormat:@"Documents/insta.igo"];
//            NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fileNameToSave];
//            NSLog(@"jpg path %@",jpgPath);
//            
//            NSString *newJpgPath = [NSString stringWithFormat:@"file://%@",jpgPath];
//            NSLog(@"with File path %@",newJpgPath);
//            
//            NSURL *igImageHookFile = [[NSURL alloc]initFileURLWithPath:newJpgPath];
//            NSLog(@"url Path %@",igImageHookFile);
//            

            
//            self.documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:@"http://google.com"]];
//            [self.documentController setDelegate:self];
//            [self.documentController setUTI:@"com.instagram.exclusivegram"];
//            [self.documentController presentOpenInMenuFromRect:rect inView:self.view animated:YES];
            
            [[UIApplication sharedApplication] openURL:instagramURL];
            
        } else {
            NSLog (@"Instagram not found");
        }
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
