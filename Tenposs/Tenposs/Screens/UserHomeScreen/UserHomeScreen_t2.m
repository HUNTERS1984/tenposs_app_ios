//
//  UserHomeScreen_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/10/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "UserHomeScreen_t2.h"
#import "MBCircularProgressBarView.h"
#import "GrandViewController.h"
#import "UserData.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+LoadingView.h"
#import "GlobalMapping.h"
#import "SettingsEditProfileScreen.h"

#import "PointManager.h"
#import "AuthenticationManager.h"

@interface UserHomeScreen_t2 ()

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userEmail;
@property (weak, nonatomic) IBOutlet UILabel *mileInfo;
@property (weak, nonatomic) IBOutlet UILabel *pointCount;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *mileGraph;
@property (weak, nonatomic) IBOutlet UILabel *pointInfo;
@property (weak, nonatomic) IBOutlet UIImageView *barcode;
@property (weak, nonatomic) IBOutlet UIView *editProfileView;

@property (strong, nonatomic) NSDictionary *userPointData;

@end

@implementation UserHomeScreen_t2

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.view layoutIfNeeded];
    
    _avatar.layer.cornerRadius = _avatar.bounds.size.width/2;
    _avatar.clipsToBounds = YES;
    _avatar.layer.borderWidth = 2;
    _avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    [_avatar setContentMode:UIViewContentModeScaleAspectFill];
    
    _editProfileView.layer.cornerRadius = _editProfileView.bounds.size.width/2;
    _editProfileView.clipsToBounds = YES;
    
    _backgroundImage.clipsToBounds = YES;
    
    _infoView.layer.cornerRadius = 5;
    _infoView.clipsToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileUpdated:) name:NOTI_USER_PROFILE_UPDATED object:nil];
    
    GrandViewController *parent = (GrandViewController *)self.parentViewController;
    
    if(parent){
        [parent setNavigationBarStyle:NavigationBarStyleLight];
    }
    
    [self displayDetail];
}

- (void)displayDetail{
    UserData *user = [UserData shareInstance];
    
    [_avatar sd_setImageWithURL:[NSURL URLWithString:[user getUserAvatarUrl] ]];
    
    [_backgroundImage sd_setImageWithURL:[NSURL URLWithString:@"https://media.timeout.com/images/102917922/image.jpg"]];
    [_userName setText:[user getUserName]];
    [_userEmail setText:[user getUserEmail]];
    
    [self getUserPoint];
}

- (void)getUserPoint{
    __weak UserHomeScreen_t2 *weakSelf = self;
    [[PointManager sharedInstance] PointGetUserPointWithCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
        CommonResponse *data = (CommonResponse *)resultData;
        if (isSuccess) {
            if (data.data) {
                _userPointData = [data.data mutableCopy];
                [weakSelf setupValueView];
            }
        }else{
            if (data) {
                if (data.code == ERROR_INVALID_TOKEN) {
                    [[AuthenticationManager sharedInstance] AuthRefreshTokenWithCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
                        CommonResponse *data = (CommonResponse *)resultData;
                        if (isSuccess) {
                            if (data && data.code == ERROR_OK) {
                                [[PointManager sharedInstance] PointGetUserPointWithCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
                                    if (data.data) {
                                        _userPointData = [data.data mutableCopy];
                                        [weakSelf setupValueView];
                                    }
                                }];
                            }else if(data.code == ERROR_REFRESH_TOKEN_INVALID){
                                [weakSelf removeAllInfoView];
                                [weakSelf invalidateCurrentUserSession];
                            }
                        }else{
                            if (data.code == ERROR_REFRESH_TOKEN_INVALID) {
                                [weakSelf removeAllInfoView];
                                [weakSelf invalidateCurrentUserSession];
                            }
                        }
                    }];
                }
            }else{
                [self showErrorScreen:@"ERROR" andRetryButton:^{
                    [weakSelf getUserPoint];
                }];
            }
        }
    }];
}

- (void)setupValueView{
    [_mileInfo setText:[NSString stringWithFormat:@"%ldポイント獲得まであと、%ldマイル", (long)[self getNextPoint], (long)[self getNextMile]]];
//    [_pointInfo setText:[NSString stringWithFormat:@"tenpossポイント : %ldポイント",(long)[self getCurrentPoint]]];
    [_pointInfo setText:@"tenpossポイント"];
    [_pointCount setText:[NSString stringWithFormat:@"%ldポイント",(long)[self getCurrentPoint]]];
    _mileGraph.maxValue = (CGFloat)[self getNextMile];
    
    [self generateBarCode:[[UserData shareInstance] getAuthUserID]];
    
    [self removeAllInfoView];
    
    if ([self getCurrentMile] > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.mileGraph setValue:(CGFloat)[self getCurrentMile] animateWithDuration:1];
        });
    }
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    GrandViewController *parent = (GrandViewController *)self.parentViewController;
    if(parent){
        [parent setNavigationBarStyle:NavigationBarStyleDefault];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_USER_PROFILE_UPDATED object:nil];
}

- (void)profileUpdated:(NSNotification *) notification{
    [self showLoadingViewWithMessage:@""];
    [self displayDetail];
}

- (NSString *)title{
    return @"";
}

- (NSInteger) getNextPoint{
    return [[_userPointData objectForKey:@"next_points"] integerValue];
}

- (NSInteger)getCurrentPoint{
    return [[_userPointData objectForKey:@"points"] integerValue];
}

- (NSInteger)getNextMile{
    return [[_userPointData objectForKey:@"next_miles"] integerValue];
}

- (NSInteger)getCurrentMile{
    return [[_userPointData objectForKey:@"miles"] integerValue];
}

- (IBAction)editProfileTapped:(id)sender {
    SettingsEditProfileScreen *screen = [SettingsEditProfileScreen new];
    if(self.navigationController){
        [self.navigationController pushViewController:screen animated:YES];
    }
}


-(void)generateBarCode:(NSString *)qrString{
    
    NSData *stringData = [qrString dataUsingEncoding:NSASCIIStringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    //    [qrFilter setValue:[CIColor colorWithRed:155 green:155 blue:155] forKey:@"inputColor1"];
    //    [qrFilter setValue:[CIColor colorWithRed:255 green:255 blue:255] forKey:@"inputColor0"];
    
    CIImage *qrImage = qrFilter.outputImage;
    
//    CIFilter *grayFilter = [CIFilter filterWithName:@"CIFalseColor"];
//    [grayFilter setValue:qrImage forKey:@"inputImage"];
//    [grayFilter setValue:[CIColor colorWithRed:0.59f green:0.59f blue:0.59f] forKey:@"inputColor0"];
//    [grayFilter setValue:[CIColor colorWithRed:1.0f green:1.0f blue:1.0f] forKey:@"inputColor1"];
//    
//    CIImage *grayImage = grayFilter.outputImage;
    
//    float scaleX = _barcode.frame.size.width / grayImage.extent.size.width;
//    float scaleY = _barcode.frame.size.height / grayImage.extent.size.height;
//    
//    grayImage = [grayImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];

    float scaleX = _barcode.frame.size.width / qrImage.extent.size.width;
    float scaleY = _barcode.frame.size.height / qrImage.extent.size.height;
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    _barcode.image = [UIImage imageWithCIImage:qrImage
                                         scale:[UIScreen mainScreen].scale
                                   orientation:UIImageOrientationUp];
}

@end
