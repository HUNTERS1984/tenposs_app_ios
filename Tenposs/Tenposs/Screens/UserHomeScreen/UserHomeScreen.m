//
//  UserHomeScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/11/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "UserHomeScreen.h"
#import "UIViewController+LoadingView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserData.h"
#import "GrandViewController.h"
#import "MBCircularProgressBarView.h"

@interface UserHomeScreen ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *mileInfo;

@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *mileGraph;
@property (weak, nonatomic) IBOutlet UILabel *pointInfo;
@property (weak, nonatomic) IBOutlet UIImageView *barcode;

@end

@implementation UserHomeScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showLoadingViewWithMessage:@""];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.view layoutIfNeeded];
    _avatar.layer.cornerRadius = _avatar.bounds.size.width/2;
    _avatar.clipsToBounds = YES;
    _headerImage.clipsToBounds = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    GrandViewController *parent = (GrandViewController *)self.parentViewController;
    
    if(parent){
        [parent setNavigationBarStyle:NavigationBarStyleLight];
    }
    
    UserData *user = [UserData shareInstance];
    
    [_avatar sd_setImageWithURL:[NSURL URLWithString:[user getUserAvatarUrl] ]];
    
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:@"http://ryecityschools.schoolfusion.us/modules/groups/homepagefiles/cms/496886/Image/Webquests/Japan/Cities/tokyo1.jpg"]];
    [_userName setText:[user getUserName]];
    
    [_mileInfo setText:[NSString stringWithFormat:@"%ld ポイント 獲得まで あと %ld マイル", (long)[self getTotalPoint], (long)[self getTotalMile]]];
    [_pointInfo setText:[NSString stringWithFormat:@"tenpossポイント : %ldポイント",(long)[self getCurrentPoint]]];
    
    _mileGraph.maxValue = (CGFloat)[self getTotalMile];
    
    [self generateBarCode:@"123123"];
    
    [self removeAllInfoView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mileGraph setValue:(CGFloat)[self getCurrentMile] animateWithDuration:1];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    GrandViewController *parent = (GrandViewController *)self.parentViewController;
    if(parent){
        [parent setNavigationBarStyle:NavigationBarStyleDefault];
    }
}

- (NSString *)title{
    return @"私のページ";
}

- (NSInteger) getTotalPoint{
    return 200;
}

- (NSInteger)getCurrentPoint{
    return 150;
}

- (NSInteger)getTotalMile{
    return 4280;
}

- (NSInteger)getCurrentMile{
    return 2500;
}

-(void)generateBarCode:(NSString *)qrString{
    
    qrString = @"123465";
    
    NSData *stringData = [qrString dataUsingEncoding:NSASCIIStringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
//    [qrFilter setValue:[CIColor colorWithRed:155 green:155 blue:155] forKey:@"inputColor1"];
//    [qrFilter setValue:[CIColor colorWithRed:255 green:255 blue:255] forKey:@"inputColor0"];
    
    CIImage *qrImage = qrFilter.outputImage;
    
    CIFilter *grayFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [grayFilter setValue:qrImage forKey:@"inputImage"];
    [grayFilter setValue:[CIColor colorWithRed:0.59f green:0.59f blue:0.59f] forKey:@"inputColor0"];
    [grayFilter setValue:[CIColor colorWithRed:1.0f green:1.0f blue:1.0f] forKey:@"inputColor1"];
    
    CIImage *grayImage = grayFilter.outputImage;
    
    float scaleX = _barcode.frame.size.width / grayImage.extent.size.width;
    float scaleY = _barcode.frame.size.height / grayImage.extent.size.height;
    
    grayImage = [grayImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    _barcode.image = [UIImage imageWithCIImage:grayImage
                                         scale:[UIScreen mainScreen].scale
                                   orientation:UIImageOrientationUp];
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
