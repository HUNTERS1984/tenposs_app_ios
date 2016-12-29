//
//  QRCodeScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "QRCodeScreen.h"
#import "CouponAlertView.h"
#import "UIUtils.h"
#import "StaffListPopup.h"
#import "UserData.h"
#import "Const.h"
#import "Utils.h"
#import "StaffCommunicator.h"


@interface QRCodeScreen ()

@property (weak) IBOutlet UIImageView *QRImage;
@property (weak) IBOutlet UIActivityIndicatorView *indicator;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *couponTitle;
@property (weak, nonatomic) IBOutlet UIButton *useButton;

@property (strong, nonatomic) StaffListPopup *staffPopup;

@property (strong, nonatomic) StaffCategory *staffCate;
@property (weak, nonatomic) IBOutlet UIView *dimBackground;
@property (weak, nonatomic) IBOutlet UIView *staffListView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation QRCodeScreen

static NSString *ident = @"cell_ident";

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.view layoutIfNeeded];
    _contentView.layer.cornerRadius = 5.0f;
    _useButton.layer.cornerRadius = 5.0f;
    
    [_dimBackground setHidden:YES];
    [_staffListView setHidden:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_staffCate) {
        _staffCate = [StaffCategory new];
    }
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ident];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_indicator startAnimating];
    
    if (_QRString && ![_QRString isEqualToString:@""]) {
        [self generateQRCode:_QRString];
    }
    [_couponTitle setText:self.coupon.title];
    [_indicator stopAnimating];
    [_indicator setHidden:YES];
}

- (IBAction)cancelStaffList:(id)sender {
    
    [self toggleStaffList];
    
}


- (NSString *)title{
    return @"Coupone Detail";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)backgroundTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)generateQRCode:(NSString *)qrString{
    
    //qrString = @"http://google.com";
    
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

- (IBAction)useCouponTapped:(id)sender {
    if (![[UserData shareInstance] getToken]) {
        
    }else{
        
        [self toggleStaffList]; 
        
//        if (!_staffPopup) {
//            _staffPopup = [[StaffListPopup alloc] initWithNibName:NSStringFromClass([StaffListPopup class]) bundle:nil];
//        }
//        _staffPopup.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 100);
//        _staffPopup.modalPresentationStyle = UIModalPresentationPopover;
//        __weak QRCodeScreen *weakSelf = self;
//        _staffPopup.delegate = weakSelf;
//        // configure the Popover presentation controller
//        UIPopoverPresentationController *popController = [_staffPopup popoverPresentationController];
//        popController.popoverLayoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
//        popController.permittedArrowDirections = 0;
//        popController.sourceView = self.view;
//        popController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxX(self.view.bounds),1,1);
//        popController.delegate = weakSelf;
//        
//        [self presentViewController:_staffPopup animated:YES completion:nil];
    }
}

- (void)toggleStaffList{
    if (_staffListView.isHidden && _dimBackground.isHidden) {
        
        [_dimBackground setHidden:NO];
        
        [UIView animateWithDuration:.35
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [_staffListView setHidden:NO];
                             CGRect originFrame = _staffListView.frame;
                             _staffListView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - originFrame.size.height , CGRectGetWidth(originFrame), CGRectGetHeight(originFrame));
                         }
                         completion:^(BOOL finished){
                             if (!_staffCate.staffs || [_staffCate.staffs count] <= 0) {
                                 [self getStaffList];
                             }
                         }];
    }else{
        [UIView animateWithDuration:.35
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect originFrame = _staffListView.frame;
                             _staffListView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height + originFrame.size.height , CGRectGetWidth(originFrame), CGRectGetHeight(originFrame));
                         }
                         completion:^(BOOL finished){
                             [_dimBackground setHidden:YES];
                             [_staffListView setHidden:YES];
                         }];
        
    }
}

- (void)staffChose:(StaffObject *)staff{
    [self toggleStaffList];
    [self sendCouponUserRequest:staff];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendCouponUserRequest:(StaffObject *)staff{
    UserData *user = [UserData shareInstance];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    NSString *token = [user getToken];
    NSString *app_user_id = [user getAuthUserID];
    if ([app_user_id isKindOfClass:[NSNumber class]]) {
        app_user_id = [((NSNumber *)app_user_id) stringValue];
    }
    NSArray *sigs = [NSArray arrayWithObjects:token,currentTime,app_user_id,[@(_coupon.coupon_id) stringValue],[@(staff.staff_id) stringValue],APP_SECRET,nil];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObject:[user getToken] forKey: KeyAPI_TOKEN];
     [params setObject:currentTime  forKey:   KeyAPI_TIME];
     [params setObject:[user getAppUserID]  forKey:  KeyAPI_APP_USER_ID ];
     [params setObject:[@(_coupon.coupon_id) stringValue]  forKey:   KeyAPI_COUPON_ID];
     [params setObject:[@(staff.staff_id) stringValue] forKey:   KeyAPI_STAFF_ID];
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

#pragma mark - UIPopoverPresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

- (UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style{
    return self;
}

- (void)getStaffList{
    StaffCommunicator *request = [StaffCommunicator new];
    Bundle *params = [Bundle new];
    [params put:KeyAPI_APP_ID value:APP_ID];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    [params put:KeyAPI_TIME value:currentTime];
    NSArray *strings = [NSArray arrayWithObjects:APP_ID,currentTime,@"0",APP_SECRET,nil];
    [params put:KeyAPI_SIG value:[Utils getSigWithStrings:strings]];
    [params put:KeyAPI_CATEGORY_ID value:@"0"];
    [params put:KeyAPI_PAGE_INDEX value:[@(_staffCate.pageindex) stringValue]];
    [params put:KeyAPI_PAGE_SIZE value:@"20"];
    [request execute:params withDelegate:self];
}


#pragma mark - UITableViewDataSource

-(StaffObject *)staffForIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    return [_staffCate.staffs objectAtIndex:index];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_staffCate.staffs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    
    StaffObject *staff = [self staffForIndexPath:indexPath];
    
    if(staff){
        [cell.textLabel setText:staff.name];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StaffObject *staff = [self staffForIndexPath:indexPath];
    [self staffChose:staff];
}

#pragma mark - TenpossCommunicatorDelegate

- (void)completed:(TenpossCommunicator *)request data:(Bundle *)responseParams{
    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
    NSError *error = nil;
    if (errorCode != ERROR_OK) {
        NSString *errorDomain = [CommunicatorConst getErrorMessage:errorCode];
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
    }else{
        StaffResponse *data = (StaffResponse *)[responseParams get:KeyResponseObject];
        if (data.staffs && [data.staffs count] > 0) {
            _staffCate.total_staffs = data.total_staffs;
            for (StaffObject *staff in data.staffs) {
                [_staffCate addStaff:staff];
            }
        }else{
            if ([_staffCate.staffs count] > 0) {
                error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_CONTENT_FULLY_LOADED] code:ERROR_CONTENT_FULLY_LOADED userInfo:nil];
                
            }else{
                error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_DETAIL_DATASOURCE_NO_CONTENT] code:ERROR_DETAIL_DATASOURCE_NO_CONTENT userInfo:nil];
            }
        }
        [self.tableView reloadData];
    }
}


@end
