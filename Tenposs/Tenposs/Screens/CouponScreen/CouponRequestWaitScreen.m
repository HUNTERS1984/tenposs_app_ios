//
//  CouponRequestWaitScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/16/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "CouponRequestWaitScreen.h"
#import "UIViewController+LoadingView.h"
#import "UserData.h"
#import "NetworkCommunicator.h"
#import "Const.h"
#import "Utils.h"
#import "UIImageView+WebCache.h"

@interface CouponRequestWaitScreen ()

@end

@implementation CouponRequestWaitScreen

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.view setNeedsLayout];
    
    _avatar.clipsToBounds = YES;
    _avatar.layer.cornerRadius = _avatar.frame.size.width/2;
    _avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatar.layer.borderWidth = 2;
    
    
    _circleView2.layer.cornerRadius = _circleView2.frame.size.width/2;
    _circleView2.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.1].CGColor;
    _circleView2.layer.borderWidth = 2;
    
    _circleView1.layer.cornerRadius = _circleView1.frame.size.width/2;
    _circleView1.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.1].CGColor;
    _circleView1.layer.borderWidth = 2;
    
    _circleView3.layer.cornerRadius = _circleView3.frame.size.width/2;
    _circleView3.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.1].CGColor;
    _circleView3.layer.borderWidth = 2;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_avatar sd_setImageWithURL:[NSURL URLWithString:_staff.image_url]];
    [self sendCouponToStaff];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendCouponToStaff{
    
    if (!_coupon || !_staff) {
        NSLog(@"ERROR!!!!! %@", @"Nor coupon or staff should be nil at this stage!");
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    UserData *user = [UserData shareInstance];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    NSString *token = [user getToken];
    NSString *app_user_id = [user getAuthUserID];
    if ([app_user_id isKindOfClass:[NSNumber class]]) {
        app_user_id = [((NSNumber *)app_user_id) stringValue];
    }
    NSArray *sigs = [NSArray arrayWithObjects:token,currentTime,app_user_id,[@(_coupon.coupon_id) stringValue],[@(_staff.staff_id) stringValue],APP_SECRET,nil];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObject:APP_ID forKey: KeyAPI_APP_ID];
    [params setObject:currentTime  forKey:   KeyAPI_TIME];
    [params setObject:[user getAppUserID]  forKey:  KeyAPI_APP_USER_ID ];
    [params setObject:[@(_coupon.coupon_id) stringValue]  forKey:   KeyAPI_COUPON_ID];
    [params setObject:[@(_staff.staff_id) stringValue] forKey:   KeyAPI_STAFF_ID];
    [params setObject:[Utils getSigWithStrings:sigs] forKey: KeyAPI_SIG  ];
    
    
    [[NetworkCommunicator shareInstance] POSTNoParamsV2:API_COUPON_USE parameters:params onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
        NSString *status;
        if (isSuccess) {
            status = @"success";
        }else{
            status = @"failed";
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_COUPON_REQUEST object:nil userInfo:@{@"status":status}];
    }];
}
- (IBAction)onOKButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
