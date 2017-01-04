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
#import "UserData.h"
#import "Const.h"
#import "Utils.h"
#import "NetworkCommunicator.h"
#import "CouponAlertView.h"

@interface ScannerScreen ()<CouponAlertViewDelegate>

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
- (NSString*)title {
    return @"QRコードリーダー";
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
            ;
        }
    }
    if (code == nil)
        return;
    
    [_session stopRunning];
    [_previewLayer removeFromSuperlayer];
    
    NSLog(@"QR Code: %@", code);
    
    UserData *user = [UserData shareInstance];
    NSString *auth_user_id = [[user getUserData] objectForKey:@"auth_user_id"];
    if ([auth_user_id isKindOfClass:[NSNumber class]]) {
        auth_user_id = [((NSNumber *)auth_user_id) stringValue];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];

    [params setObject:auth_user_id forKey:KeyAPI_STAFF_AUTH_ID];
    [params setObject:APP_ID forKey:KeyAPI_APP_ID];
    [params setObject:code forKey:KeyAPI_COUPON_CODE];
    [params setObject:[user getToken] forKey: KeyAPI_TOKEN];
    
    [[NetworkCommunicator shareInstance] POSTNoParamsV2:API_COUPON_USE parameters:params onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
        NSString *status;
        if (isSuccess) {
            if (dictionary) {
                NSError *err;
                CouponRequestModel *request = [[CouponRequestModel alloc] initWithDictionary:dictionary error:&err];
                request.coupon_id = [[dictionary objectForKey:@"id"] integerValue];
                CouponAlertView *alert = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CouponAlertView class])];
                alert.coupon = request;
                [alert showFrom:self withType:CouponAlertImageTypeSend title:request.title description:request.desc positiveButton:@"同意する" negativeButton:@"同意しない" delegate:self];
            }
        }else{
            status = @"failed";
            [self.navigationController popViewControllerAnimated:TRUE];
        }

    }];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Scanner result"
//                                                    message:code
//                                                   delegate:nil
//                                          cancelButtonTitle:@"閉じる"
//                                          otherButtonTitles:nil];
//    [alert show];
}

- (void)proccessRetrieveCode:(NSString *)code withType:(NSString *)type{
    if([type isEqualToString:AVMetadataObjectTypeQRCode]){
        
    } else if ([type isEqualToString:AVMetadataObjectTypeCode128Code]){
        
    }
}
- (void)onPositiveButtonTapped:(CouponAlertView *)alertView{
    //TODO: send accept request
    if (alertView.coupon) {
        NSMutableDictionary * params = [NSMutableDictionary new];
        [params setObject:@"approve" forKey:KeyAPI_ACTION];
        [params setObject:[@(alertView.coupon.coupon_id) stringValue] forKey:KeyAPI_COUPON_ID];
        [params setObject:APP_ID forKey:KeyAPI_APP_ID];
        [params setObject:alertView.coupon.code forKey:KeyAPI_COUPON_CODE];
        
        [[NetworkCommunicator shareInstance] POSTNoParams:API_COUPON_ACCEPT parameters:params onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
            if(isSuccess){
                [self showAlertView:@"情報" message:@"承認しました"];
                [self.navigationController popViewControllerAnimated:TRUE];
            }else{
                [self showAlertView:@"エラー" message:@"承認できませんでした"];
            }
        }];
    }
    
    [alertView dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)onNegativeButtonTapped:(CouponAlertView *)alertView{
    
    if (alertView.coupon) {
        NSMutableDictionary * params = [NSMutableDictionary new];
        [params setObject:@"reject" forKey:KeyAPI_ACTION];
        [params setObject:[@(alertView.coupon.coupon_id) stringValue] forKey:KeyAPI_COUPON_ID];
        [params setObject:APP_ID forKey:KeyAPI_APP_ID];
        [params setObject:alertView.coupon.code forKey:KeyAPI_COUPON_CODE];
        
        [[NetworkCommunicator shareInstance] POSTNoParams:API_COUPON_ACCEPT parameters:params onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
            if(isSuccess){
                [self showAlertView:@"情報" message:@"同意しない"];
                [self.navigationController popViewControllerAnimated:TRUE];
            }else{
            }
        }];
    }
    
    [alertView dismissViewControllerAnimated:YES completion:nil];
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
