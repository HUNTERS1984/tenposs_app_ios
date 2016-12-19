//
//  ScannerScreen.m
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/14/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import "ScannerScreen.h"
#import "UIFont+Themify.h"
#import "HexColors.h"

@interface ScannerScreen ()

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVCaptureDevice *device;

@property (weak, nonatomic) IBOutlet UIView *scannableRect;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;

@end

@implementation ScannerScreen

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.view layoutIfNeeded];
    
    _scannableRect.layer.borderWidth = 10;
    _scannableRect.layer.borderColor = [UIColor whiteColor].CGColor;
    _scannableRect.layer.cornerRadius = 20;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    
    [self setupScanner];
}

- (void)didPressBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationBar{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStylePlain target:self action:@selector(didPressBackButton)];
    self.navigationItem.leftBarButtonItem = backButton;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationItem setBackBarButtonItem:nil];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIFont themifyFontOfSize:20/*[UIUtils getTextSizeWithType:settings.font_size]*/], NSFontAttributeName,
                                                                   [UIColor colorWithHexString:@"15C8C8"], NSForegroundColorAttributeName,
                                                                   nil]
                                                         forState:UIControlStateNormal];
    [self.navigationItem.leftBarButtonItem setTitle:[NSString stringWithFormat: [UIFont stringForThemifyIdentifier:@"ti-angle-left"]]];
}

- (void)setupScanner{
    _session = [[AVCaptureSession alloc] init];
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    // Display full screen
    _previewLayer.frame = CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
    
    // Add the video preview layer to the view
    [self.view.layer addSublayer:_previewLayer];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_device
                                                                        error:&error];
    if (input) {
        [_session addInput:input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //    output.rectOfInterest = [_previewLayer metadataOutputRectOfInterestForRect:_scannableRect.frame];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //[output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeEAN13Code]];
    [_session addOutput:output];
    [_session startRunning];
    
    [output setMetadataObjectTypes:[output availableMetadataObjectTypes]];
    
    
    [self.view bringSubviewToFront:_scannableRect];
    [self.view bringSubviewToFront:_flashButton];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    NSString *code = nil;
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            code = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            break;
        }else if ([metadata.type isEqualToString:AVMetadataObjectTypeCode128Code]){
            code =  [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
        }else {
            code = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
        }
    }
    [_session stopRunning];
    [_previewLayer removeFromSuperlayer];
    
    NSLog(@"QR Code: %@", code);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Scanner result"
                                                    message:code
                                                   delegate:nil
                                          cancelButtonTitle:@"閉じる"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)proccessRetrieveCode:(NSString *)code withType:(NSString *)type{
    if([type isEqualToString:AVMetadataObjectTypeQRCode]){
        
    } else if ([type isEqualToString:AVMetadataObjectTypeCode128Code]){
        
    }
}

- (IBAction)toggleFlash:(id)sender {
    
    if (_device) {
        if (_device.hasFlash) {
            NSError *error;
            [_device lockForConfiguration:&error];
            if (!error) {
                switch (_device.flashMode) {
                    case AVCaptureFlashModeOff:
                        if (_device.isFlashAvailable) {
                            [_device setFlashMode:AVCaptureFlashModeOn];
                        }
                        break;
                    case AVCaptureFlashModeAuto:
                    case AVCaptureFlashModeOn:
                    {
                        [_device setFlashMode:AVCaptureFlashModeOff];
                    }
                        break;
                    default:
                        break;
                }
            }
        }
    }
}

@end
