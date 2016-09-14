//
//  QRCodeScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "QRCodeScreen.h"

@interface QRCodeScreen ()

@property (weak) IBOutlet UIImageView *QRImage;
@property (weak) IBOutlet UIActivityIndicatorView *indicator;
@property (weak) IBOutlet UIButton *closeButton;

@end

@implementation QRCodeScreen

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_indicator startAnimating];
    
    if (_QRString && ![_QRString isEqualToString:@""]) {
        [self generateQRCode:_QRString];
    }
    
    [_indicator stopAnimating];
    [_indicator setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)generateQRCode:(NSString *)qrString{
    
    qrString = @"http://google.com";
    
    NSData *stringData = [qrString dataUsingEncoding: NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    float scaleX = _QRImage.frame.size.width / qrImage.extent.size.width;
    float scaleY = _QRImage.frame.size.height / qrImage.extent.size.height;
    
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    _QRImage.image = [UIImage imageWithCIImage:qrImage
                                                 scale:[UIScreen mainScreen].scale
                                           orientation:UIImageOrientationUp];
}

-(IBAction)closeButtonClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
