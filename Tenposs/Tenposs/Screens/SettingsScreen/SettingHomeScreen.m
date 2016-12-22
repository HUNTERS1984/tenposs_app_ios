//
//  SettingHomeScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/25/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SettingHomeScreen.h"
#import "UserData.h"
#import "Settings_Text.h"
#import "Settings_Text_Switch.h"
#import "UIFont+Themify.h"
#import "UserData.h"
#import "GetPushSettingsCommunicator.h"
#import "Utils.h"
#import "AppConfiguration.h"
#import "SettingsEditProfileScreen.h"
#import "Const.h"
#import "HexColors.h"
#import "CompanyInfoScreen.h"
#import "UserPrivacyScreen.h"
#import "UIViewController+LoadingView.h"
#import "LoginScreen.h"
#import "PushNotificationManager.h"

#define SET_EDIT_PROFILE    @0
#define SET_PUSH_NEWS       @1
#define SET_PUSH_COUPON     @2
#define SET_CHANGE_DEVICE   @3
#define SET_COMPANY_INFO    @4
#define SET_USER_PRIVACY    @5
#define SET_USER_LOGOUT     @6
#define SET_PUSH_RANK       @7
#define SET_PUSH_CHAT       @8

@interface SettingHomeScreen ()

@property(strong, nonatomic) NSMutableArray *settingArrays;

@end

@implementation SettingHomeScreen

static NSDictionary *settingsNames;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    if([self respondsToSelector:@selector(edgesForExtendedLayout)]){
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
    [self showLoadingViewWithMessage:@""];
    
     settingsNames = @{
                  SET_EDIT_PROFILE : @"プロフィール編集",
                  SET_PUSH_NEWS : @"お知らせを受け取る",
                  SET_PUSH_COUPON: @"クーポン情報を受け取る",
                  SET_CHANGE_DEVICE: @"機種変更時引継ぎコード発行",
                  SET_COMPANY_INFO: @"運営会社",
                  SET_USER_PRIVACY: @"採用情報",
                  SET_USER_LOGOUT: @"ログアウト"};
    
    [self buildSettingsFunctions];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.clearsSelectionOnViewWillAppear = YES;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([Settings_Text class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([Settings_Text class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([Settings_Text_Switch class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([Settings_Text_Switch class])];
    
    
}

- (NSString *)title{
    return @"設定";
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([[UserData shareInstance] getToken]) {
        
        [[PushNotificationManager sharedInstance] PushGetUserPushSettingsWithCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
            CommonResponse *response = (CommonResponse *)resultData;
            if (isSuccess) {
                NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                if(response && response.data){
                    NSMutableDictionary *pushSetting = [response.data mutableCopy];
                    if([pushSetting objectForKey:@"coupon"]){
                        NSString *status = [pushSetting objectForKey:@"coupon"];
                        if ([status isEqualToString:@"0"]) {
                            [userDef setObject:SVALUE_OFF forKey:SKEY_PUSH_COUPON];
                        }else{
                            [userDef setObject:SVALUE_ON forKey:SKEY_PUSH_COUPON];
                        }
                    }
                    
                    if ([pushSetting objectForKey:@"news"]){
                        NSString *status = [pushSetting objectForKey:@"news"];
                        if ([status isEqualToString:@"0"]) {
                            [userDef setObject:SVALUE_OFF forKey:SKEY_PUSH_NEWS];
                        }else{
                            [userDef setObject:SVALUE_ON forKey:SKEY_PUSH_NEWS];
                        }
                    }
                    
                    if ([pushSetting objectForKey:@"chat"]){
                        NSString *status = [pushSetting objectForKey:@"chat"];
                        if ([status isEqualToString:@"0"]) {
                            [userDef setObject:SVALUE_OFF forKey:SKEY_PUSH_CHAT];
                        }else{
                            [userDef setObject:SVALUE_ON forKey:SKEY_PUSH_CHAT];
                        }
                    }
                    
                    if ([pushSetting objectForKey:@"ranking"]){
                        NSString *status = [pushSetting objectForKey:@"ranking"];
                        if ([status isEqualToString:@"0"]) {
                            [userDef setObject:SVALUE_OFF forKey:SKEY_PUSH_RANKING];
                        }else{
                            [userDef setObject:SVALUE_ON forKey:SKEY_PUSH_RANKING];
                        }
                    }
                }
            }else{
                if(response && response.code == ERROR_INVALID_TOKEN){
                    [self invalidateCurrentUserSession];
                }
            }
            [self previewData];
        }];
    }else{
        [self removeAllInfoView];
    }
}

-(void)buildSettingsFunctions{
    if (!_settingArrays) {
        _settingArrays = [NSMutableArray new];
    }else{
        [_settingArrays removeAllObjects];
    }
    
    UserData *user = [UserData shareInstance];
    
    if (![user getToken]) {
        //Not login
        [_settingArrays addObjectsFromArray:[NSArray arrayWithObjects:SET_COMPANY_INFO,SET_USER_PRIVACY, nil]];
    }else{
        // User logged in
        [_settingArrays addObjectsFromArray:[NSArray arrayWithObjects:SET_EDIT_PROFILE,SET_PUSH_NEWS,SET_PUSH_COUPON,SET_CHANGE_DEVICE,SET_COMPANY_INFO,SET_USER_PRIVACY,SET_USER_LOGOUT, nil]];
    }
    
    
}

- (void)previewData{
    [self.tableView reloadData];
    [self removeAllInfoView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSNumber *)functionForIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    if (index < [_settingArrays count]) {
        return [_settingArrays objectAtIndex:index];
    }else{
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_settingArrays count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSNumber *function = [self functionForIndexPath:indexPath];
    
    if ([function  isEqual: SET_EDIT_PROFILE]
        || [function  isEqual: SET_CHANGE_DEVICE]
        || [function isEqual:SET_USER_PRIVACY]
        || [function isEqual:SET_COMPANY_INFO]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Settings_Text class]) forIndexPath:indexPath];
        [((Settings_Text *)cell).title setText:[settingsNames objectForKey:function]];
        NSString *title =[NSString stringWithFormat: @"%@", [UIFont stringForThemifyIdentifier:@"ti-angle-right"]];
        NSMutableAttributedString *atString = [[NSMutableAttributedString alloc] initWithString:title attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                                 [UIFont themifyFontOfSize:20/*[UIUtils getTextSizeWithType:settings.font_size]*/], NSFontAttributeName,
                                                                                                                 [UIColor colorWithHexString:@"#727272"], NSForegroundColorAttributeName,nil]];
        [((Settings_Text *)cell).indicator setAttributedText:atString];
        
    }else if ([function isEqual:SET_USER_LOGOUT]){
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Settings_Text class]) forIndexPath:indexPath];
        [((Settings_Text *)cell).title setText:[settingsNames objectForKey:function]];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Settings_Text_Switch class]) forIndexPath:indexPath];
        [((Settings_Text_Switch *)cell).title setText:[settingsNames objectForKey:function]];
        if ([function isEqual:SET_PUSH_NEWS]) {
            ((Settings_Text_Switch *)cell).set_switch.tag = [SET_PUSH_NEWS integerValue];
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            NSString *status = [userDef objectForKey:SKEY_PUSH_NEWS];
            if (!status) {
                [((Settings_Text_Switch *)cell).set_switch setOn:YES];
            }else{
                [((Settings_Text_Switch *)cell).set_switch setOn:[status isEqualToString:SVALUE_ON]];
            }
        }else if ([function isEqual:SET_PUSH_COUPON]){
            ((Settings_Text_Switch *)cell).set_switch.tag = [SET_PUSH_COUPON integerValue];
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            NSString *status = [userDef objectForKey:SKEY_PUSH_COUPON];
            if (!status) {
                [((Settings_Text_Switch *)cell).set_switch setOn:YES];
            }else{
                [((Settings_Text_Switch *)cell).set_switch setOn:[status isEqualToString:SVALUE_ON]];
            }
        }
        [((Settings_Text_Switch *)cell).set_switch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSNumber *function = [self functionForIndexPath:indexPath];
    
    if ([function isEqual:SET_EDIT_PROFILE]) {
        SettingsEditProfileScreen *screen = [SettingsEditProfileScreen new];
        
        [self.navigationController pushViewController:screen animated:YES];
    }else if ([function isEqual:SET_CHANGE_DEVICE]){
        
    }else if ([function isEqual:SET_COMPANY_INFO]){
        [self.navigationController pushViewController:[[CompanyInfoScreen alloc] init] animated:NO];
    }else if ([function isEqual:SET_USER_PRIVACY]){
        [self.navigationController pushViewController:[[UserPrivacyScreen alloc] init] animated:NO];
    }else if ([function isEqual:SET_USER_LOGOUT]){
        [self signOut];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSString *)getPushValue{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if ([userDef objectForKey:SKEY_PUSH_COUPON]) {
        NSString *status = [userDef objectForKey:SKEY_PUSH_COUPON];
        if ([status isEqualToString:SVALUE_ON]) {
            return SVALUE_ON;
        }
    }
    
    if ([userDef objectForKey:SKEY_PUSH_NEWS]) {
        NSString *status = [userDef objectForKey:SKEY_PUSH_NEWS];
        if ([status isEqualToString:SVALUE_ON]) {
            return SVALUE_ON;
        }
    }
    
    if ([userDef objectForKey:SKEY_PUSH_CHAT]) {
        NSString *status = [userDef objectForKey:SKEY_PUSH_NEWS];
        if ([status isEqualToString:SVALUE_ON]) {
            return SVALUE_ON;
        }
    }
    
    if ([userDef objectForKey:SKEY_PUSH_RANKING]) {
        NSString *status = [userDef objectForKey:SKEY_PUSH_RANKING];
        if ([status isEqualToString:SVALUE_ON]) {
            return SVALUE_ON;
        }
    }
    return SVALUE_OFF;
}

- (void)changeSwitch:(id)sender{
    if ([sender isKindOfClass:[UISwitch class]]) {
        NSMutableDictionary *notificationChanges = [NSMutableDictionary new];
        [notificationChanges setObject:@"0" forKey:KeyAPI_RANKING];
        [notificationChanges setObject:@"0" forKey:KeyAPI_CHAT];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        if (((UISwitch *)sender).tag == [SET_PUSH_NEWS integerValue]) {
            if ([sender isOn]) {
                [userDef setObject:SVALUE_ON forKey:SKEY_PUSH_NEWS];
            }else{
                [userDef setObject:SVALUE_OFF forKey:SKEY_PUSH_NEWS];
            }
        }else if (((UISwitch *)sender).tag == [SET_PUSH_COUPON integerValue]){
            if ([sender isOn]) {
                [userDef setObject:SVALUE_ON forKey:SKEY_PUSH_COUPON];
            }else{
                [userDef setObject:SVALUE_OFF forKey:SKEY_PUSH_COUPON];
            }
        }
        [userDef synchronize];
        NSString *newsStatusStr = [userDef objectForKey:SKEY_PUSH_NEWS];
        NSNumber *newsStatus;
        if (!newsStatusStr) {
            newsStatusStr = SVALUE_ON;
            newsStatus = @(1);
            [userDef setObject:SVALUE_ON forKey:SKEY_PUSH_NEWS];
        }else{
            if ([newsStatusStr isEqualToString:SVALUE_ON]) {
                newsStatus = @(1);
            }else{
                newsStatus = @(0);
            }
        }
        
        NSString *couponStatusStr = [userDef objectForKey:SKEY_PUSH_COUPON];
        NSNumber *couponStatus;
        if (!couponStatusStr) {
            couponStatusStr = SVALUE_ON;
            couponStatus = @(1);
            [userDef setObject:SVALUE_ON forKey:SKEY_PUSH_COUPON];
        }else{
            if ([couponStatusStr isEqualToString:SVALUE_ON]) {
                couponStatus = @(1);
            }else{
                couponStatus = @(0);
            }
        }
        [userDef synchronize];
        
        [notificationChanges setObject:@"0" forKey:KeyAPI_RANKING];
        [notificationChanges setObject:newsStatus forKey:KeyAPI_NEWS];
        [notificationChanges setObject:@"0" forKey:KeyAPI_CHAT];
        [notificationChanges setObject:couponStatus forKey:KeyAPI_COUPON];
        [[UserData shareInstance] updatePushSetting:[notificationChanges mutableCopy]];
        [notificationChanges removeAllObjects];
    }
}

#pragma mark - TenpossCommunicatorDelegate

- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
    NSError *error = nil;
    if (errorCode != ERROR_OK) {
        NSString *errorDomain = [CommunicatorConst getErrorMessage:errorCode];
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
        if(errorCode == ERROR_INVALID_TOKEN){
            [self invalidateCurrentUserSession];
        }else{
            [self showErrorScreen:@"Error has occurred!" andRetryButton:^{
                [request execute:responseParams withDelegate:self];
            }];
        }
    }else{
        NSDictionary *data = (NSDictionary *) [responseParams get:KeyResponseObject];
        if (data) {
            if ([[data objectForKey:@"data"] objectForKey:@"push_setting"]) {
                NSDictionary *pushSetting = [[data objectForKey:@"data"] objectForKey:@"push_setting"];
                NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                if([pushSetting objectForKey:@"coupon"]){
                    NSString *status = [pushSetting objectForKey:@"coupon"];
                    if ([status isEqualToString:@"0"]) {
                        [userDef setObject:SVALUE_OFF forKey:SKEY_PUSH_COUPON];
                    }else{
                        [userDef setObject:SVALUE_ON forKey:SKEY_PUSH_COUPON];
                    }
                }
                
                if ([pushSetting objectForKey:@"news"]){
                    NSString *status = [pushSetting objectForKey:@"news"];
                    if ([status isEqualToString:@"0"]) {
                        [userDef setObject:SVALUE_OFF forKey:SKEY_PUSH_NEWS];
                    }else{
                        [userDef setObject:SVALUE_ON forKey:SKEY_PUSH_NEWS];
                    }
                }
                
                if ([pushSetting objectForKey:@"chat"]){
                    NSString *status = [pushSetting objectForKey:@"chat"];
                    if ([status isEqualToString:@"0"]) {
                        [userDef setObject:SVALUE_OFF forKey:SKEY_PUSH_CHAT];
                    }else{
                        [userDef setObject:SVALUE_ON forKey:SKEY_PUSH_CHAT];
                    }
                }
                
                if ([pushSetting objectForKey:@"ranking"]){
                    NSString *status = [pushSetting objectForKey:@"ranking"];
                    if ([status isEqualToString:@"0"]) {
                        [userDef setObject:SVALUE_OFF forKey:SKEY_PUSH_RANKING];
                    }else{
                        [userDef setObject:SVALUE_ON forKey:SKEY_PUSH_RANKING];
                    }
                }
                [userDef synchronize];
            }
        }
        
        [self previewData];
    }
}

- (void)begin:(TenpossCommunicator*)request data:(Bundle*) responseParams{}

-( void)cancelAllRequest{}


@end
