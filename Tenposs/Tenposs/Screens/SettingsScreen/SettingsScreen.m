//
//  SettingsScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/11/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SettingsScreen.h"
#import "UIViewController+LoadingView.h"
#import "Settings_Avatar.h"
#import "Setting_EditText.h"
#import "Settings_Expand_Selector.h"
#import "Settings_Social_Connect.h"
#import "UserData.h"
#import "RequestBuilder.h"
#import "TenpossCommunicator.h"
#import <InAppSettingsKit/IASKSettingsReader.h>
#import "Const.h"
#import "NetworkCommunicator.h"
#import "SettingsTableViewController.h"
#import "UIUtils.h"
#import "SettingsProvineScreen.h"
#import "OAuthScreen.h"
#import "Utils.h"
#import "UIUtils.h"
#import "UIFont+Themify.h"
#import "HexColors.h"
#import "AppConfiguration.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TwitterKit.h>
#import "GetPushSettingsCommunicator.h"
#import <SDWebImage/UIImageView+WebCache.h>

//#import "UserData.h"

#define USERID_TAG 100
#define USERNAME_TAG 101
#define USEREMAIL_TAG 102

@interface SettingsScreen () <UITextFieldDelegate, UIActionSheetDelegate, TenpossCommunicatorDelegate>{
    NSString *cur_userId;
    NSString *cur_userName;
    NSString *cur_userEmail;
}
@property SettingsTableViewController *settingView;
@property UIImagePickerController *imagePickerController;

@property (strong, nonatomic)NSMutableDictionary *userProfileChanges;
@property (strong, nonatomic)NSMutableDictionary *notificationChanges;

@end

@implementation SettingsScreen

- (void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingDidChange:) name:kIASKAppSettingChanged object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showLoadingViewWithMessage:@""];
    
    UserData *userData = [UserData shareInstance];
    cur_userId = [userData getUserID];
    cur_userName = [userData getUserName];
    cur_userEmail = [userData getUserEmail];
    _userProfileChanges = [NSMutableDictionary new];
    _notificationChanges = [NSMutableDictionary new];
    
    self.settingView = [self appSettingsViewController];
    self.settingView.view.frame = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height);// self.view.bounds;
    [self.view addSubview:self.settingView.view];
    [self addChildViewController:self.settingView];
    [self.settingView didMoveToParentViewController:self];
    
    //[self.navigationController pushViewController:_settingView animated:NO];
    
    if ([[UserData shareInstance] getToken]) {
        GetPushSettingsCommunicator *request = [GetPushSettingsCommunicator new];
        Bundle *params = [Bundle new];
        [params put:KeyAPI_TOKEN value:[[UserData shareInstance] getToken]];
        NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
        [params put:KeyAPI_TIME value:currentTime];
        NSString *store_id = [[AppConfiguration sharedInstance] getStoreId];
        NSArray *strings = [NSArray arrayWithObjects:APP_ID,currentTime,store_id,APP_SECRET,nil];
        [params put:KeyAPI_SIG value:[Utils getSigWithStrings:strings]];
        [request execute:params withDelegate:self];
    }    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self removeLoadingView];
}

- (void)didPressBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (SettingsTableViewController*)appSettingsViewController {
    if (!_settingView) {
        _settingView = [[SettingsTableViewController alloc] init];
        _settingView.delegate = self;
        
        ///TODO: open when available
        BOOL enabled = [[UserData shareInstance] getToken]!=nil;
        _settingView.hiddenKeys = enabled ? nil : [NSSet setWithObjects:@"keyEditProfile", nil];
        self.settingView.showCreditsFooter = NO;
    }
    return _settingView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title{
    //TODO: need localize
    return @"設定";
}

#pragma mark - IASKSettingsDelegate

- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender{
    
    NSLog(@"Settings did end");
    
    if ([_userProfileChanges count] > 0) {
        [[UserData shareInstance] updateProfile:[_userProfileChanges mutableCopy]];
        [_userProfileChanges removeAllObjects];
    }
}

- (void)settingDidChange:(NSNotification*)notification {
    if ([notification.userInfo.allKeys.firstObject isEqual:SETTINGS_KeyUserAvatar]) {
        UIImage *chooseImage = (UIImage *)[[notification.userInfo mutableCopy] objectForKey:SETTINGS_KeyUserAvatar];
        [[UserData shareInstance] setUserAvatarImg:chooseImage];
        
        ///Add to profile change dict
       // [_userProfileChanges setObject:chooseImage forKey:KeyAPI_AVATAR];
        
    }else if ([notification.userInfo.allKeys.firstObject isEqual:SETTINGS_KeyUsername]) {
        NSString *username = [[notification.userInfo mutableCopy] objectForKey:SETTINGS_KeyUsername];
    
        ///Add to profile change dict
        [_userProfileChanges setObject:username forKey:KeyAPI_USERNAME_NAME];
    
    }else if ([notification.userInfo.allKeys.firstObject isEqual:SETTINGS_KeyUserEmail]){
        NSString *userEmail = [[notification.userInfo mutableCopy] objectForKey:SETTINGS_KeyUserEmail];
        
        ///Add to profile change dict
//        [_userProfileChanges setObject:userEmail forKey:KeyAPI_EMAIL];
        
        [[UserData shareInstance] setUserEmail:userEmail];
        if([self.navigationController.visibleViewController isKindOfClass:[IASKAppSettingsViewController class]]){
            [((IASKAppSettingsViewController *)self.navigationController.visibleViewController).tableView reloadData];
        }
        [self.settingView.tableView reloadData];
        
    }else if ([notification.userInfo.allKeys.firstObject isEqualToString:SETTINGS_KeyUserGender]){
        NSInteger gender = [[[notification.userInfo mutableCopy] objectForKey:SETTINGS_KeyUserGender] integerValue];
        
        ///Add to profile change dict
        [_userProfileChanges setObject:@(gender) forKey:KeyAPI_GENDER];
        
            [[UserData shareInstance] setUserGender:gender];
            if([self.navigationController.visibleViewController isKindOfClass:[IASKAppSettingsViewController class]]){
                [((IASKAppSettingsViewController *)self.navigationController.visibleViewController).tableView reloadData];
            }
            [self.settingView.tableView reloadData];
        
    }else if([notification.userInfo.allKeys.firstObject isEqualToString:SETTINGS_KeyUserProvine]){
        NSString *provine = @"abc";//[notification.userInfo objectForKey:SETTINGS_KeyUserProvine];
        ///Add to profile change dict
        [_userProfileChanges setObject:provine forKey:KeyAPI_ADDRESS];
        
        [[UserData shareInstance] setUserProvine:provine];
        if([self.navigationController.visibleViewController isKindOfClass:[IASKAppSettingsViewController class]]){
            [((IASKAppSettingsViewController *)self.navigationController.visibleViewController).tableView reloadData];
        }
    }else if ([notification.userInfo.allKeys.firstObject isEqualToString:SETTINGS_KeyUserInstaAccessToken]){
        //TODO: send instagram token
        NSMutableDictionary *socialProfile = [notification.userInfo objectForKey:SETTINGS_KeyUserInstaAccessToken];
        
        ///Add to social change dict
        
        NSLog(@"INSTAGRAM profile = %@", socialProfile);
        
        [[UserData shareInstance] updateSocialSetting:socialProfile];
        
    }else if ([notification.userInfo.allKeys.firstObject isEqualToString:@"keyPushNotification"]){
        NSLog(@"General Push changed");
        NSString *pushSet = [[notification.userInfo objectForKey:@"keyPushNotification"] stringValue];
        if ([pushSet isEqualToString:@"0"]) {
            [_notificationChanges setObject:@"0" forKey:KeyAPI_RANKING];
            [_notificationChanges setObject:@"0" forKey:KeyAPI_NEWS];
            [_notificationChanges setObject:@"0" forKey:KeyAPI_CHAT];
            [_notificationChanges setObject:@"0" forKey:KeyAPI_COUPON];
            
        }else{
            [_notificationChanges setObject:@"1" forKey:KeyAPI_RANKING];
            [_notificationChanges setObject:@"1" forKey:KeyAPI_NEWS];
            [_notificationChanges setObject:@"1" forKey:KeyAPI_CHAT];
            [_notificationChanges setObject:@"1" forKey:KeyAPI_COUPON];
        }
        [[UserData shareInstance] updatePushSetting:[_notificationChanges mutableCopy]];
        [_notificationChanges removeAllObjects];
        
    }else if ([notification.userInfo.allKeys.firstObject isEqualToString:@"keyCouponPushNotification"]){
        NSLog(@"Coupon Push changed");
        NSString *pushSet = [[notification.userInfo objectForKey:@"keyCouponPushNotification"]stringValue];
        [_notificationChanges setObject:@"0" forKey:KeyAPI_RANKING];
        [_notificationChanges setObject:@"0" forKey:KeyAPI_NEWS];
        [_notificationChanges setObject:@"0" forKey:KeyAPI_CHAT];
        [_notificationChanges setObject:pushSet forKey:KeyAPI_COUPON];
        [[UserData shareInstance] updatePushSetting:[_notificationChanges mutableCopy]];
        [_notificationChanges removeAllObjects];
    }
}

#pragma mark UITableView cell customization
- (CGFloat)tableView:(UITableView*)tableView heightForSpecifier:(IASKSpecifier*)specifier{
    if ([specifier.key isEqualToString:@"KeyUserAvatar"]) {
        return 88;
    }else{
        return 44;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForSpecifier:(IASKSpecifier*)specifier{
    UITableViewCell *cell = nil;
    UserData *userData = [UserData shareInstance];
    if ([specifier.key isEqualToString:@"KeyUserAvatar"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Settings_Avatar class])];
        if (!cell) {
            cell = (Settings_Avatar *)[[[NSBundle mainBundle]
                                        loadNibNamed:NSStringFromClass([Settings_Avatar class])
                                        owner:self
                                                                 options:nil] objectAtIndex:0];
        }
        ///Config Avatar
        ((Settings_Avatar *)cell).avatar.layer.cornerRadius = ((Settings_Avatar *)cell).avatar.bounds.size.width/2;
        ((Settings_Avatar *)cell).avatar.layer.borderWidth = 1;
        ((Settings_Avatar *)cell).avatar.layer.borderColor = [UIColor lightGrayColor].CGColor;

        NSString *avaURL = [userData getUserAvatarUrl];
        
        if (avaURL && ![avaURL isKindOfClass:[NSNull class]]) {
            [((Settings_Avatar *)cell).avatar sd_setImageWithURL:[NSURL URLWithString:avaURL] ];
        }else{
            [((Settings_Avatar *)cell).avatar setImage:[UIImage imageNamed:@"user_icon"]];
        }
        
        [((Settings_Avatar *)cell).title setText:specifier.title];
    }else if ([specifier.key isEqualToString:@"KeyUserID"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Setting_EditText class])];
        if (!cell) {
            cell = (Setting_EditText *)[[[NSBundle mainBundle]
                                        loadNibNamed:NSStringFromClass([Setting_EditText class])
                                        owner:self
                                        options:nil] objectAtIndex:0];
        }
        
        //TODO: Get UserData and fill the text
        [((Setting_EditText *)cell).title setText:specifier.title];
        [((Setting_EditText *)cell).text  setPlaceholder:NSLocalizedString(@"user_id",nil)];
        [((Setting_EditText *)cell).text  setText:[userData getUserID]];
        ((Setting_EditText *)cell).text.tag = USERID_TAG;
        ((Setting_EditText *)cell).text.delegate = self;
    }else if ([specifier.key isEqualToString:@"KeyUsername"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Setting_EditText class])];
        if (!cell) {
            cell = (Setting_EditText *)[[[NSBundle mainBundle]
                                         loadNibNamed:NSStringFromClass([Setting_EditText class])
                                         owner:self
                                         options:nil] objectAtIndex:0];
        }
        
        //TODO: Get UserData and fill the text
        [((Setting_EditText *)cell).title setText:specifier.title];
        [((Setting_EditText *)cell).text  setPlaceholder:NSLocalizedString(@"user_id",nil)];
        [((Setting_EditText *)cell).text  setText:[userData getUserName]];
        ((Setting_EditText *)cell).text.tag = USERNAME_TAG;
        ((Setting_EditText *)cell).text.delegate = self;
    }else if ([specifier.key isEqualToString:@"KeyUserEmail"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Setting_EditText class])];
        if (!cell) {
            cell = (Setting_EditText *)[[[NSBundle mainBundle]
                                         loadNibNamed:NSStringFromClass([Setting_EditText class])
                                         owner:self
                                         options:nil] objectAtIndex:0];
        }
        //TODO: Get UserData and fill the text
        [((Setting_EditText *)cell).title setText:specifier.title];
        [((Setting_EditText *)cell).text  setPlaceholder:NSLocalizedString(@"email_address",nil)];
        NSString *email = [userData getUserEmail];
        [((Setting_EditText *)cell).text setText:email];
        ((Setting_EditText *)cell).text.delegate = self;
        ((Setting_EditText *)cell).text.tag = USEREMAIL_TAG;
    }else if ([specifier.key isEqualToString:@"KeyUserGender"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Settings_Expand_Selector class])];
        if (!cell) {
            cell = (Settings_Expand_Selector *)[[[NSBundle mainBundle]
                                         loadNibNamed:NSStringFromClass([Settings_Expand_Selector class])
                                         owner:self
                                         options:nil] objectAtIndex:0];
        }
        //TODO: Get UserData and fill the text
        [((Settings_Expand_Selector *)cell).title setText:specifier.title];
        //TODO: get info from UserData
        [((Settings_Expand_Selector *)cell).text  setText:[userData getUserGenderString]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }else if ([specifier.key isEqualToString:@"KeyUserProvine"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Settings_Expand_Selector class])];
        if (!cell) {
            cell = (Settings_Expand_Selector *)[[[NSBundle mainBundle]
                                                 loadNibNamed:NSStringFromClass([Settings_Expand_Selector class])
                                                 owner:self
                                                 options:nil] objectAtIndex:0];
        }
        //TODO: Get UserData and fill the text
        [((Settings_Expand_Selector *)cell).title setText:specifier.title];
        //TODO: get info from UserData
        [((Settings_Expand_Selector *)cell).text  setText:NSLocalizedString([userData getUserProvine], nil)];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }else if ([specifier.key isEqualToString:@"KeyFacebookConnect"]){
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Settings_Social_Connect class])];
        if (!cell) {
            cell = (Settings_Expand_Selector *)[[[NSBundle mainBundle]
                                                 loadNibNamed:NSStringFromClass([Settings_Social_Connect class])
                                                 owner:self
                                                 options:nil] objectAtIndex:0];
        }
        [((Settings_Social_Connect *)cell).socialIcon setImage:[UIImage imageNamed:@"facebook_icon"]];
        [((Settings_Social_Connect *)cell).socialName setText:specifier.title];
        ((Settings_Social_Connect *)cell).socialIcon.clipsToBounds = YES;
    
        NSString *status = [[UserData shareInstance] getFacebookStatus];
        if ([status isEqualToString:@"1"]) {
            [((Settings_Social_Connect *)cell).connectButton setBackgroundColor:[UIColor lightGrayColor]];
            [((Settings_Social_Connect *)cell).connectButton setTitleColor:[UIColor colorWithHexString:@"212121"] forState:UIControlStateNormal];
            [((Settings_Social_Connect *)cell).connectButton setTitle:NSLocalizedString(@"setting_disconnect", nil) forState:UIControlStateNormal];
        }else{
            [((Settings_Social_Connect *)cell).connectButton setBackgroundColor:[UIColor colorWithHexString:@"18C1BF"]];
            [((Settings_Social_Connect *)cell).connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [((Settings_Social_Connect *)cell).connectButton setTitle:NSLocalizedString(@"setting_connect", nil) forState:UIControlStateNormal];
            [((Settings_Social_Connect *)cell).connectButton addTarget:self action:@selector(doFacebookLogin) forControlEvents:UIControlEventTouchUpInside];
        }
    
    }else if ([specifier.key isEqualToString:@"KeyTwitterConnect"]){
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Settings_Social_Connect class])];
        if (!cell) {
            cell = (Settings_Expand_Selector *)[[[NSBundle mainBundle]
                                                 loadNibNamed:NSStringFromClass([Settings_Social_Connect class])
                                                 owner:self
                                                 options:nil] objectAtIndex:0];
        }
        [((Settings_Social_Connect *)cell).socialIcon setImage:[UIImage imageNamed:@"twitter_icon"]];
        [((Settings_Social_Connect *)cell).socialName setText:specifier.title];
        ((Settings_Social_Connect *)cell).socialIcon.clipsToBounds = YES;
        
        NSString *status = [[UserData shareInstance] getTwitterStatus];
        if ([status isEqualToString:@"1"]) {
            [((Settings_Social_Connect *)cell).connectButton setBackgroundColor:[UIColor lightGrayColor]];
            [((Settings_Social_Connect *)cell).connectButton setTitleColor:[UIColor colorWithHexString:@"212121"] forState:UIControlStateNormal];
            [((Settings_Social_Connect *)cell).connectButton setTitle:NSLocalizedString(@"setting_disconnect", nil) forState:UIControlStateNormal];
        }else{
            [((Settings_Social_Connect *)cell).connectButton setBackgroundColor:[UIColor colorWithHexString:@"18C1BF"]];
            [((Settings_Social_Connect *)cell).connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [((Settings_Social_Connect *)cell).connectButton setTitle:NSLocalizedString(@"setting_connect", nil) forState:UIControlStateNormal];
            [((Settings_Social_Connect *)cell).connectButton addTarget:self action:@selector(doTwitterLogin) forControlEvents:UIControlEventTouchUpInside];

        }
    }else if ([specifier.key isEqualToString:@"KeyInstagramConnect"]){
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Settings_Social_Connect class])];
        if (!cell) {
            cell = (Settings_Expand_Selector *)[[[NSBundle mainBundle]
                                                 loadNibNamed:NSStringFromClass([Settings_Social_Connect class])
                                                 owner:self
                                                 options:nil] objectAtIndex:0];
        }
        [((Settings_Social_Connect *)cell).socialIcon setImage:[UIImage imageNamed:@"instagram_icon"]];
        [((Settings_Social_Connect *)cell).socialName setText:specifier.title];
        ((Settings_Social_Connect *)cell).socialIcon.clipsToBounds = YES;
        
        NSString *status = [[UserData shareInstance] getInstagramStatus];
        if ([status isEqualToString:@"1"]) {
            [((Settings_Social_Connect *)cell).connectButton setBackgroundColor:[UIColor lightGrayColor]];
            [((Settings_Social_Connect *)cell).connectButton setTitleColor:[UIColor colorWithHexString:@"212121"] forState:UIControlStateNormal];
            [((Settings_Social_Connect *)cell).connectButton setTitle:NSLocalizedString(@"setting_disconnect", nil) forState:UIControlStateNormal];
            
        }else{
            [((Settings_Social_Connect *)cell).connectButton setBackgroundColor:[UIColor colorWithHexString:@"18C1BF"]];
            [((Settings_Social_Connect *)cell).connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [((Settings_Social_Connect *)cell).connectButton setTitle:NSLocalizedString(@"setting_connect", nil) forState:UIControlStateNormal];
            [((Settings_Social_Connect *)cell).connectButton addTarget:self action:@selector(doTwitterLogin) forControlEvents:UIControlEventTouchUpInside];
            [((Settings_Social_Connect *)cell).connectButton addTarget:self action:@selector(doInstagramLogin) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)doFacebookLogin{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email", @"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
            NSLog(@"error %@",error);
        } else if (result.isCancelled) {
            // Handle cancellations
            NSLog(@"Cancelled");
        } else {
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                NSString *token = result.token.tokenString;
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         NSLog(@"fetched user:%@", result);
                         NSMutableDictionary *params = [NSMutableDictionary new];
                         [params setObject:@"1" forKey:KeyAPI_SOCIAL_TYPE];
                         [params setObject:[result objectForKey:@"id"] forKey:KeyAPI_SOCIAL_ID];
                         [params setObject:token forKey:KeyAPI_SOCIAL_TOKEN];
                         [params setObject:@"" forKey:KeyAPI_SOCIAL_SECRET];
                         [params setObject:[result objectForKey:@"name"] forKey:KeyAPI_NICKNAME];
                         [[UserData shareInstance] updateSocialSetting:params];
                     }
                 }];
            }
        }
    }];
}

- (void)doTwitterLogin{
    [[Twitter sharedInstance] logInWithViewController:self methods:TWTRLoginMethodAll completion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setObject:@"2" forKey:KeyAPI_SOCIAL_TYPE];
            [params setObject:[session userID] forKey:KeyAPI_SOCIAL_ID];
            [params setObject:[session authToken] forKey:KeyAPI_SOCIAL_TOKEN];
            [params setObject:[session authTokenSecret] forKey:KeyAPI_SOCIAL_SECRET];
            [params setObject:[session userName] forKey:KeyAPI_NICKNAME];
            [[UserData shareInstance] updateSocialSetting:params];
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}

- (void)doInstagramLogin{
    OAuthScreen *oAuth = [[UIUtils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([OAuthScreen class])];
    [self.navigationController pushViewController:oAuth animated:YES];
}

- (void)settingsViewController:(IASKAppSettingsViewController*)sender tableView:(UITableView *)tableView didSelectCustomViewSpecifier:(IASKSpecifier*)specifier{
    
    if ([specifier.key isEqualToString:@"KeyUserAvatar"]) {
        if (!_imagePickerController) {
            _imagePickerController = [[UIImagePickerController alloc] init];
        }
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerController.delegate = self;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }else if ([specifier.key isEqualToString:@"KeyUserGender"]){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:NSLocalizedString(@"gender",nil)
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"gender_male",nil),NSLocalizedString(@"gender_female",nil)
                                      ,nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
    }else if ([specifier.key isEqualToString:SETTINGS_KeyUserProvine]){
        SettingsProvineScreen *provineScreen = [[SettingsProvineScreen alloc]initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:provineScreen animated:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case USERID_TAG:{
            //TODO: need implementation
        }
            break;
        case USERNAME_TAG:{
            NSString *username = textField.text;
            if (!cur_userName) {
                if (username && ![username isEqualToString:@""]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged object:self userInfo:@{SETTINGS_KeyUsername :username}];
                }
            }else{
                if (username && ![username isEqualToString:cur_userName]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged object:self userInfo:@{SETTINGS_KeyUsername :username}];
                }
            }
        }
            break;
        case USEREMAIL_TAG:{
            NSString *userEmail = textField.text;
            if (!cur_userEmail) {
                if (userEmail && ![userEmail isEqualToString:@""]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged object:self userInfo:@{SETTINGS_KeyUserEmail:userEmail}];
                }
            }else{
                if (userEmail && ![userEmail isEqualToString:cur_userEmail]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged object:self userInfo:@{SETTINGS_KeyUserEmail:userEmail}];
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UI

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //MALE
        [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged object:self userInfo:@{SETTINGS_KeyUserGender:@"0"}];
    }else if (buttonIndex == 1){
        //FEMALE
        [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged object:self userInfo:@{SETTINGS_KeyUserGender:@"1"}];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [_imagePickerController dismissViewControllerAnimated:YES completion:nil];
    UIImage *chooseImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    if (chooseImage) {
        [_userProfileChanges setObject:chooseImage forKey:KeyAPI_AVATAR];
        [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged object:self userInfo:@{SETTINGS_KeyUserAvatar:chooseImage}];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TenpossCommunicatorDelegate

- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
    NSError *error = nil;
    if (errorCode != ERROR_OK) {
        NSString *errorDomain = [CommunicatorConst getErrorMessage:errorCode];
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
    }else{
        NSDictionary *data = (NSDictionary *) [responseParams get:KeyResponseObject];
        if (data) {
            if ([[data objectForKey:@"data"] objectForKey:@"push_setting"]) {
                if([[[data objectForKey:@"data"] objectForKey:@"push_setting"] objectForKey:@"coupon"]){
                    
                }
            }
        }
    }
}

- (void)begin:(TenpossCommunicator*)request data:(Bundle*) responseParams{}

-( void)cancelAllRequest{}


@end
