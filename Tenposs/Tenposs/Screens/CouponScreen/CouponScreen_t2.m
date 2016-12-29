//
//  CouponScreen_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "CouponScreen_t2.h"
#import "DataModel.h"
#import "UIViewController+LoadingView.h"
#import "CouponRequestWaitScreen.h"
#import "AppConfiguration.h"
#import "UIFont+Themify.h"
#import "HexColors.h"
#import "Const.h"
#import "Utils.h"
#import "Item_Staff_Table_t2.h"
#import "CouponDataSource_t2.h"
#import "UIButton+HandleBlock.h"
#import "CouponDetailScreen.h"

static inline CGFloat PMSquaredDistanceFromRectToPoint(CGRect rect, CGPoint point)
{
    if (CGRectContainsPoint(rect, point)) {
        return 0.0f;
    }
    else {
        CGPoint closestPoint = rect.origin;
        
        if (point.x > CGRectGetMaxX(rect)) {
            closestPoint.x += rect.size.width;
        }
        else if (point.x > CGRectGetMinX(rect)) {
            closestPoint.x = point.x;
        }
        
        if (point.y > CGRectGetMaxY(rect)) {
            closestPoint.y += rect.size.height;
        }
        else if (point.y > CGRectGetMinY(rect)) {
            closestPoint.y = point.y;
        }
        
        CGFloat dx = point.x - closestPoint.x;
        CGFloat dy = point.y - closestPoint.y;
        
        return dx*dx + dy*dy;
    }
}

@interface CouponScreen_t2 ()<UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *dimBackground;
@property (weak, nonatomic) IBOutlet UIView *staffListView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PMCenteredCircularCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property(assign, nonatomic) NSInteger currentCouponIndex;
@property (strong, nonatomic) CouponObject *currentCoupon;

@property (strong, nonatomic) CouponObject *coupon;

@end

@implementation CouponScreen_t2

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)loadView{
    [super loadView];
    self.dataSource = [[CouponDataSource_t2 alloc] initWithDelegate:self andStoreId:self.store_id];
    self.dataSource.couponUseDelegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    [self.dataSource registerClassForCollectionView:self.collectionView];
    self.collectionView.dataSource = self.dataSource;
    [self.collectionView setDelegate:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (_tableView) {
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Staff_Table_t2 class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([Item_Staff_Table_t2 class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    [_staffListView setHidden:YES];
    [_dimBackground setHidden:YES];
    
    if (self.navigationController && [self.navigationController.viewControllers count] > 1) {
        
        AppSettings *settings = [[AppConfiguration sharedInstance] getAvailableAppSettings];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(didPressBackButton)];
        self.navigationItem.leftBarButtonItem = backButton;
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.navigationItem setBackBarButtonItem:nil];
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                       [UIFont themifyFontOfSize:20/*[UIUtils getTextSizeWithType:settings.font_size]*/], NSFontAttributeName,
                                                                       [UIColor colorWithHexString:settings.title_color], NSForegroundColorAttributeName,
                                                                       nil]
                                                             forState:UIControlStateNormal];
        [self.navigationItem.leftBarButtonItem setTitle:[NSString stringWithFormat: @"%@", [UIFont stringForThemifyIdentifier:@"ti-angle-left"]]];
    }
    
    [self getStaffList];
    
    [self showLoadingViewWithMessage:@""];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if(self.dataSource){
        [self.dataSource loadData];
    }else{
        NSAssert(NO, @"DataSource cannot be nil at this stage!");
    }
}

- (void)didPressBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title{
    return @"クーポン";
}

- (void)setDataSource:(CouponDataSource_t2 *)dataSource{
    _dataSource = dataSource;
    if (_collectionView) {
        _collectionView.dataSource = _dataSource;
        [_collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CouponObject *coupon = (CouponObject *)[self.dataSource itemAtIndexPath:indexPath];
    CouponDetailScreen *controller = [[UIUtils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CouponDetailScreen class])];
    controller.coupon = coupon;
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dataSource sizeForCellAtIndexPath:indexPath withCollectionWidth:collectionView.bounds.size.width];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return [self.dataSource insetForSection:section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return [self.dataSource minimumLineSpacingForSection:section];;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return [self.dataSource minimumInteritemSpacingForSection:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return [self.dataSource sizeForHeaderAtSection:section inCollectionView:collectionView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return [self.dataSource sizeForFooterAtSection:section inCollectionView:collectionView];
}

#pragma mark - Staff TableView methods

- (IBAction)cancelStaffList:(id)sender {
    
    [self toggleStaffList];
    
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
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendCouponUserRequest:(StaffObject *)staff{
    AppSettings *settings = [[AppConfiguration sharedInstance] getAvailableAppSettings];
    CouponRequestWaitScreen *controller = (CouponRequestWaitScreen *)[GlobalMapping getCouponRequestWaitScreen:settings.template_id andExtra:nil];
    controller.coupon = _currentCoupon;
    controller.staff = staff;
    if (!controller) {
        return;
    }
    if (self.mainNavigationController) {
        [self.mainNavigationController presentViewController:controller animated:YES completion:nil];
    }else{
        if(self.navigationController){
            [self.navigationController presentViewController:controller animated:YES completion:nil];
        }else{
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
    
//    UserData *user = [UserData shareInstance];
//    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
//    NSString *token = [user getToken];
//    NSString *app_user_id = [user getAppUserID];
//    if ([app_user_id isKindOfClass:[NSNumber class]]) {
//        app_user_id = [((NSNumber *)app_user_id) stringValue];
//    }
//    NSArray *sigs = [NSArray arrayWithObjects:token,currentTime,app_user_id,[@(_coupon.coupon_id) stringValue],[@(staff.staff_id) stringValue],APP_SECRET,nil];
//    
//    NSMutableDictionary *params = [NSMutableDictionary new];
//    
//    [params setObject:[user getToken] forKey: KeyAPI_TOKEN];
//    [params setObject:currentTime  forKey:   KeyAPI_TIME];
//    [params setObject:[user getAppUserID]  forKey:  KeyAPI_APP_USER_ID ];
//    [params setObject:[@(_coupon.coupon_id) stringValue]  forKey:   KeyAPI_COUPON_ID];
//    [params setObject:[@(staff.staff_id) stringValue] forKey:   KeyAPI_STAFF_ID];
//    [params setObject:[Utils getSigWithStrings:sigs] forKey: KeyAPI_SIG  ];
//    
//    [[NetworkCommunicator shareInstance] POSTNoParamsV2:API_COUPON_USE parameters:params onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
//        NSString *status;
//        if (isSuccess) {
//            status = @"success";
//        }else{
//            status = @"failed";
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_COUPON_REQUEST object:nil userInfo:@{@"status":status}];
//    }];
}

#pragma mark - Private methods

- (void)handleDataSourceError:(NSError *)error{
    if (!error) {
        [self removeAllInfoView];
        [self.collectionView reloadData];
        _pageControl.numberOfPages = [_dataSource numberOfItem];
        return;
    }
    [self removeAllInfoView];
    NSString *message = @"Unknow Error";
    switch (error.code) {
        case ERROR_DATASOURCE_NO_CONTENT:{
            //TODO: need localize
            message = NSLocalizedString(@"NO CONTENT",nil);
            [self showErrorScreen:message];
        }
            break;
        case ERROR_DETAIL_DATASOURCE_NO_CONTENT:{
            message = NSLocalizedString(@"NO CONTENT",nil);
            [self showErrorScreen:message];
        }
            break;
        case ERROR_CONTENT_FULLY_LOADED:{
            
        }
            break;
        case ERROR_DETAIL_DATASOURCE_IS_LAST:{
        }break;
        case ERROR_DETAIL_DATASOURCE_IS_FIRST:{
        }break;
        case ERROR_INVALID_TOKEN:{
            [self invalidateCurrentUserSession];
        }break;
        default:
            break;
    }
}

- (void)getStaffList{
    if (!_staffCate) {
        _staffCate = [[StaffCategory alloc] init];
        _staffCate.staff_cate_id = 0;
        _staffCate.pageindex = 1;
    }
    StaffCommunicator *request = [StaffCommunicator new];
    Bundle *params = [Bundle new];
    [params put:KeyAPI_APP_ID value:APP_ID];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    [params put:KeyAPI_TIME value:currentTime];
    NSArray *strings = [NSArray arrayWithObjects:APP_ID,currentTime,@"0",APP_SECRET,nil];
    [params put:KeyAPI_SIG value:[Utils getSigWithStrings:strings]];
    [params put:KeyAPI_CATEGORY_ID value:@"0"];
    [params put:KeyAPI_PAGE_INDEX value:[@(_staffCate.pageindex) stringValue]];
    [params put:KeyAPI_PAGE_SIZE value:@"30"];
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
    Item_Staff_Table_t2 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Item_Staff_Table_t2 class])     forIndexPath:indexPath];
    StaffObject *staff = [self staffForIndexPath:indexPath];
    if(staff){
        [cell configureCellWithData:staff];
        __weak CouponScreen_t2 *weakSelf = self;
        __weak StaffObject *weakStaff = staff;
        [cell.connectButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf staffChose:weakStaff];
        }];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    StaffObject *staff = [self staffForIndexPath:indexPath];
//    [self staffChose:staff];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Item_Staff_Table_t2 getHeightWithWidth:tableView.frame.size.width];
}

#pragma mark - TenpossCommunicatorDelegate

- (void)cancelAllRequest{}

- (void)begin:(TenpossCommunicator *)request data:(Bundle *)responseParams{}

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


#pragma mark - SimpleDataSourceDelegate

- (void)dataLoaded:(SimpleDataSource *)executor withError:(NSError *)error{
    [self handleDataSourceError:error];
}

- (void)needRefreshItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)needRefreshSectionAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UserCouponDelegate

- (void)onCouponUse:(CouponObject *)coupon{
    if (![[UserData shareInstance] getToken]) {
        
    }else{
        _currentCoupon = coupon;
        [self toggleStaffList];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSIndexPath *indexPathNearestToBoundsCenter = [self indexPathNearestToBoundsCenter];
    
    _currentCouponIndex = indexPathNearestToBoundsCenter.row;
    
    [_pageControl setCurrentPage:_currentCouponIndex];
}

- (CGRect) visibleRect
{
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    return visibleRect;
}

- (CGPoint) contentOffsetInBoundsCenter
{
    CGPoint middlePoint = self.collectionView.contentOffset;
    middlePoint.x += self.collectionView.bounds.size.width / 2.0f;
    middlePoint.y += self.collectionView.bounds.size.height / 2.0f;
    return middlePoint;
}

- (NSIndexPath *) indexPathNearestToBoundsCenter
{
    CGPoint contentOffsetInBoundsCenter = [self contentOffsetInBoundsCenter];
    return [self indexPathNearestToPoint:contentOffsetInBoundsCenter];
}


- (NSIndexPath *) indexPathNearestToPoint:(CGPoint)point
{
    CGRect visibleRect = [self visibleRect];
    NSIndexPath *nearestIndexPath = nil;
    CGFloat closestDistance = MAXFLOAT;
    
    if (CGRectContainsPoint(visibleRect, point)) {
        
        if (CGSizeEqualToSize(CGSizeZero, self.collectionView.contentSize) == NO) {
            
            for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
                
                CGFloat distance = [self squaredDistanceFromItemAtIndexPath:indexPath toPoint:point];
                
                if (distance < closestDistance) {
                    closestDistance = distance;
                    nearestIndexPath = indexPath;
                }
            }
        }
    }
    else {
        for (NSInteger section = 0; section < 1; section++) {
            
            NSInteger items = [_dataSource numberOfItem];
            
            for (NSInteger item = 0; item < items; item++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
                
                CGFloat distance = [self squaredDistanceFromItemAtIndexPath:indexPath toPoint:point];
                
                if (distance < closestDistance) {
                    closestDistance = distance;
                    nearestIndexPath = indexPath;
                }
            }
        }
    }
    return nearestIndexPath;
}


- (CGFloat) squaredDistanceFromItemAtIndexPath:(NSIndexPath *)indexPath toPoint:(CGPoint)point
{
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frame = attributes.frame;
    return PMSquaredDistanceFromRectToPoint(frame, point);
}


@end
