//
//  SettingsEditProfileScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/26/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SettingsEditProfileScreen.h"
#import "DataModel.h"
#import "UIViewController+LoadingView.h"
#import "OAuthScreen.h"
#import "UserData.h"
#import "GetPushSettingsCommunicator.h"
#import "Utils.h"
#import "AppConfiguration.h"
#import "Const.h"
#import "SettingsProvineScreen.h"
#import "UIUtils.h"
#import "UIFont+Themify.h"
#import "UIImage+fixOrientation.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "HexColors.h"

#import "Settings_Avatar.h"
#import "Setting_EditText.h"
#import "Settings_Expand_Selector.h"
#import "Settings_Social_Connect.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TwitterKit.h>


#define SOCIAL_CONNECT          @""
#define SOCIAL_DISCONNECT       @""

#define USERID_TAG 100
#define USERNAME_TAG 101
#define USEREMAIL_TAG 102



@interface SettingsEditProfileScreen ()<UITextFieldDelegate, UIActionSheetDelegate>

@property (strong, nonatomic)NSString *cur_userId;
@property (strong, nonatomic)NSString *cur_userName;
@property (strong, nonatomic)NSString *cur_userEmail;
@property (assign, nonatomic)NSInteger cur_gender;
@property (strong, nonatomic)NSString *cur_province;

@property (strong, nonatomic)NSMutableDictionary *userProfileChanges;
@property (strong, nonatomic)NSMutableDictionary *notificationChanges;

@property (strong, nonatomic) NSDictionary *settingNames;

@property(strong, nonatomic) NSMutableArray *settingFunction_edit;

@property(strong, nonatomic) NSMutableArray *settingFunction_social;

@property UIImagePickerController *imagePickerController;

@end

@implementation SettingsEditProfileScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *settings = [appConfig getAvailableAppSettings];
    if ([[self.navigationController viewControllers] count] > 1) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(didPressBackButton)];
        self.navigationItem.leftBarButtonItem = backButton;
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.navigationItem setBackBarButtonItem:nil];
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                       [UIFont themifyFontOfSize:20], NSFontAttributeName,
                                                                       [UIColor colorWithHexString:settings.title_color], NSForegroundColorAttributeName,
                                                                       nil]
                                                             forState:UIControlStateNormal];
        [self.navigationItem.leftBarButtonItem setTitle:[NSString stringWithFormat: @"%@", [UIFont stringForThemifyIdentifier:@"ti-angle-left"]]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsDidChange:) name:NOTI_SET_EDIT_CHANGED object:nil];
    
    [self showLoadingViewWithMessage:@""];
    
    _userProfileChanges = [NSMutableDictionary new];
    
    _settingNames = @{SET_EDIT_AVATAR:@"プロフィール写真を変更",
                      SET_EDIT_USER_ID:@"ユーザーID",
                      SET_EDIT_USER_NAME:@"ユーザー名",
                      SET_EDIT_EMAIL:@"メールアドレス",
                      SET_EDIT_GENDER:@"性别",
                      SET_EDIT_PROVINCE :@"都道府桌",
                      SET_EDIT_FACEBOOK :@"Facebook",
                      SET_EDIT_TWITTER  :@"Twitter",
                      SET_EDIT_INSTAGRAM:@"Instagram"};
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8FA"];
    
    [self buildSettingsFunctions];
    
    [self registerCell];
    
    UserData *userData = [UserData shareInstance];
    _cur_userId      = [userData getUserID];
    _cur_userName    = [userData getUserName];
    _cur_userEmail   = [userData getUserEmail];
    _cur_gender      = [userData getUserGender];
    _cur_province    = [userData getUserProvine];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self removeAllInfoView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        // View is disappearing because a new view controller was pushed onto the stack, DO NOTHING
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        // View is disappearing because it was popped from the stack, UPDATE PROFILE here
        UserData *userData = [UserData shareInstance];
        if([_userProfileChanges objectForKey:KeyAPI_AVATAR] ||
           (![_cur_userId isEqualToString:[userData getUserID]] ||
           ![_cur_userName isEqualToString:[userData getUserName]] ||
           _cur_gender != [userData getUserGender] ||
           ![_cur_province isEqualToString:[userData getUserProvine]])){
               [_userProfileChanges setObject:_cur_userName forKey:KeyAPI_USERNAME_NAME];
               [_userProfileChanges setObject:[@(_cur_gender) stringValue] forKey:KeyAPI_GENDER];
               [_userProfileChanges setObject:_cur_province forKey:KeyAPI_ADDRESS];
               
               [[UserData shareInstance] updateProfile:[_userProfileChanges mutableCopy]];
               [_userProfileChanges removeAllObjects];
               [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_SET_EDIT_CHANGED object:nil];
        }
    }
}

#pragma mark - Private methods

- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([Settings_Avatar class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([Settings_Avatar class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([Setting_EditText class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([Setting_EditText class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([Settings_Expand_Selector class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([Settings_Expand_Selector class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([Settings_Social_Connect class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([Settings_Social_Connect class])];
}

-(void)buildSettingsFunctions{
    //Edit profile function
    if (!_settingFunction_edit) {
        _settingFunction_edit = [NSMutableArray new];
    }else{
        [_settingFunction_edit removeAllObjects];
    }
    [_settingFunction_edit addObjectsFromArray:[NSArray arrayWithObjects:SET_EDIT_AVATAR,
                                                SET_EDIT_USER_ID,
                                                SET_EDIT_USER_NAME,
                                                SET_EDIT_EMAIL,
                                                SET_EDIT_GENDER,
                                                SET_EDIT_PROVINCE,
                                                nil]];
    
    //Social function
    if (!_settingFunction_social) {
        _settingFunction_social = [NSMutableArray new];
    }else{
        [_settingFunction_social removeAllObjects];
    }
    [_settingFunction_social addObjectsFromArray:[NSArray arrayWithObjects:
                                                  SET_EDIT_FACEBOOK,
                                                  SET_EDIT_TWITTER,
                                                  SET_EDIT_INSTAGRAM, nil]];
    
}

- (void)didPressBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [_settingFunction_edit count];
    }else{
        return [_settingFunction_social count];
    }
}

- (NSNumber *)functionForIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger index = indexPath.row;
    if (section == 0) {
        if (index < [_settingFunction_edit count]) {
            return [_settingFunction_edit objectAtIndex:index];
        }else{
            return nil;
        }
    }else {
        if (index < [_settingFunction_social count]) {
            return [_settingFunction_social objectAtIndex:index];
        }else{
            return nil;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    UserData *userData = [UserData shareInstance];
    NSNumber *function = [self functionForIndexPath:indexPath];
    
    if ([function isEqual:SET_EDIT_AVATAR]) {
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
        
        if ([userData getUserAvatarImg]) {
            UIImage *ava = [userData getUserAvatarImg];
            [((Settings_Avatar *)cell).avatar setImage:ava];
        }else{
            NSString *avaURL = [userData getUserAvatarUrl];
            if (avaURL && ![avaURL isKindOfClass:[NSNull class]]) {
                [((Settings_Avatar *)cell).avatar sd_setImageWithURL:[NSURL URLWithString:avaURL] ];
            }else{
                [((Settings_Avatar *)cell).avatar setImage:[UIImage imageNamed:@"user_icon"]];
            }
        }
        
        [((Settings_Avatar *)cell).title setText:[_settingNames objectForKey:SET_EDIT_AVATAR]];
        
    }else if ([function isEqual:SET_EDIT_USER_ID]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Setting_EditText class])];
        if (!cell) {
            cell = (Setting_EditText *)[[[NSBundle mainBundle]
                                         loadNibNamed:NSStringFromClass([Setting_EditText class])
                                         owner:self
                                         options:nil] objectAtIndex:0];
        }
        
        //TODO: Get UserData and fill the text
        [((Setting_EditText *)cell).title setText:[_settingNames objectForKey:SET_EDIT_USER_ID]];
        [((Setting_EditText *)cell).text  setPlaceholder:NSLocalizedString(@"user_id",nil)];
        [((Setting_EditText *)cell).text  setText:_cur_userId];
        ((Setting_EditText *)cell).text.tag = USERID_TAG;
        ((Setting_EditText *)cell).text.delegate = self;
    }else if ([function isEqual:SET_EDIT_USER_NAME]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Setting_EditText class])];
        if (!cell) {
            cell = (Setting_EditText *)[[[NSBundle mainBundle]
                                         loadNibNamed:NSStringFromClass([Setting_EditText class])
                                         owner:self
                                         options:nil] objectAtIndex:0];
        }
        
        //TODO: Get UserData and fill the text
        [((Setting_EditText *)cell).title setText:[_settingNames objectForKey:SET_EDIT_USER_NAME]];
        [((Setting_EditText *)cell).text  setPlaceholder:NSLocalizedString(@"user_id",nil)];
        [((Setting_EditText *)cell).text  setText:_cur_userName];
        ((Setting_EditText *)cell).text.tag = USERNAME_TAG;
        ((Setting_EditText *)cell).text.delegate = self;
    }else if ([function isEqual:SET_EDIT_EMAIL]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Setting_EditText class])];
        if (!cell) {
            cell = (Setting_EditText *)[[[NSBundle mainBundle]
                                         loadNibNamed:NSStringFromClass([Setting_EditText class])
                                         owner:self
                                         options:nil] objectAtIndex:0];
        }
        //TODO: Get UserData and fill the text
        [((Setting_EditText *)cell).title setText:[_settingNames objectForKey:SET_EDIT_EMAIL]];
        [((Setting_EditText *)cell).text  setPlaceholder:NSLocalizedString(@"email_address",nil)];
        NSString *email = _cur_userEmail;
        [((Setting_EditText *)cell).text setText:email];
        ((Setting_EditText *)cell).text.delegate = self;
        ((Setting_EditText *)cell).text.tag = USEREMAIL_TAG;
    }else if ([function isEqual:SET_EDIT_GENDER]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Settings_Expand_Selector class])];
        if (!cell) {
            cell = (Settings_Expand_Selector *)[[[NSBundle mainBundle]
                                                 loadNibNamed:NSStringFromClass([Settings_Expand_Selector class])
                                                 owner:self
                                                 options:nil] objectAtIndex:0];
        }
        //TODO: Get UserData and fill the text
        [((Settings_Expand_Selector *)cell).title setText:[_settingNames objectForKey:SET_EDIT_GENDER]];
        //TODO: get info from UserData
        [((Settings_Expand_Selector *)cell).text  setText:_cur_gender==0?NSLocalizedString(@"gender_male",nil):NSLocalizedString(@"gender_female",nil)];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }else if ([function isEqual:SET_EDIT_PROVINCE]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Settings_Expand_Selector class])];
        if (!cell) {
            cell = (Settings_Expand_Selector *)[[[NSBundle mainBundle]
                                                 loadNibNamed:NSStringFromClass([Settings_Expand_Selector class])
                                                 owner:self
                                                 options:nil] objectAtIndex:0];
        }
        //TODO: Get UserData and fill the text
        [((Settings_Expand_Selector *)cell).title setText:[_settingNames objectForKey:SET_EDIT_PROVINCE]];
        //TODO: get info from UserData
        [((Settings_Expand_Selector *)cell).text  setText:NSLocalizedString(_cur_province, nil)];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }else if ([function isEqual:SET_EDIT_FACEBOOK]){
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Settings_Social_Connect class])];
        if (!cell) {
            cell = (Settings_Expand_Selector *)[[[NSBundle mainBundle]
                                                 loadNibNamed:NSStringFromClass([Settings_Social_Connect class])
                                                 owner:self
                                                 options:nil] objectAtIndex:0];
        }
        [((Settings_Social_Connect *)cell).socialIcon setImage:[UIImage imageNamed:@"facebook_icon"]];
        [((Settings_Social_Connect *)cell).socialName setText:[_settingNames objectForKey:SET_EDIT_FACEBOOK]];
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

        }
                    [((Settings_Social_Connect *)cell).connectButton addTarget:self action:@selector(doSettingFacebookLogin) forControlEvents:UIControlEventTouchUpInside];
        
    }else if ([function isEqual:SET_EDIT_TWITTER]){
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Settings_Social_Connect class])];
        if (!cell) {
            cell = (Settings_Expand_Selector *)[[[NSBundle mainBundle]
                                                 loadNibNamed:NSStringFromClass([Settings_Social_Connect class])
                                                 owner:self
                                                 options:nil] objectAtIndex:0];
        }
        [((Settings_Social_Connect *)cell).socialIcon setImage:[UIImage imageNamed:@"twitter_icon"]];
        [((Settings_Social_Connect *)cell).socialName setText:[_settingNames objectForKey:SET_EDIT_TWITTER]];
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
            
        }
        [((Settings_Social_Connect *)cell).connectButton addTarget:self action:@selector(doSettingTwitterLogin) forControlEvents:UIControlEventTouchUpInside];
    }else if ([function isEqual:SET_EDIT_INSTAGRAM]){
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Settings_Social_Connect class])];
        if (!cell) {
            cell = (Settings_Expand_Selector *)[[[NSBundle mainBundle]
                                                 loadNibNamed:NSStringFromClass([Settings_Social_Connect class])
                                                 owner:self
                                                 options:nil] objectAtIndex:0];
        }
        [((Settings_Social_Connect *)cell).socialIcon setImage:[UIImage imageNamed:@"instagram_icon"]];
        [((Settings_Social_Connect *)cell).socialName setText:[_settingNames objectForKey:SET_EDIT_INSTAGRAM]];
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
        }
        
        [((Settings_Social_Connect *)cell).connectButton addTarget:self action:@selector(doSettingInstagramLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSNumber *function = [self functionForIndexPath:indexPath];
    if ([function isEqual:SET_EDIT_AVATAR]) {
        if (!_imagePickerController) {
            _imagePickerController = [[UIImagePickerController alloc] init];
        }
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerController.delegate = self;
        @try {
            [self presentViewController:_imagePickerController animated:YES completion:nil];
        } @catch (NSException *exception) {
             NSLog(@"exception:%@", exception) ;
        } @finally {
            
        }
        
    }else if ([function isEqual:SET_EDIT_GENDER]){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:NSLocalizedString(@"gender",nil)
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"gender_male",nil),NSLocalizedString(@"gender_female",nil)
                                      ,nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
    }else if ([function isEqual:SET_EDIT_PROVINCE]){
        SettingsProvineScreen *provineScreen = [[SettingsProvineScreen alloc]initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:provineScreen animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   NSNumber *function = [self functionForIndexPath:indexPath];
    if ([function isEqual:SET_EDIT_AVATAR]) {
        return 88;
    }else{
        return 44;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 44;
    }
    return 0;
}

#pragma mark - Social Login

- (void)doSettingFacebookLogin{
    NSString *status = [[UserData shareInstance] getFacebookStatus];
    if ([status isEqualToString:@"1"]) {
        [self cancelSocialProfile:@"1"];
    }else{
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
}

- (void)doSettingTwitterLogin{
    NSString *status = [[UserData shareInstance] getTwitterStatus];
    if ([status isEqualToString:@"1"]) {
        [self cancelSocialProfile:@"2"];
    }else{
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
}

- (void)doSettingInstagramLogin{
    NSString *status = [[UserData shareInstance] getInstagramStatus];
    if ([status isEqualToString:@"1"]) {
        [self cancelSocialProfile:@"3"];
    }else{
    OAuthScreen *oAuth = [[UIUtils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([OAuthScreen class])];
    [self.navigationController pushViewController:oAuth animated:YES];
    }
}

- (void)cancelSocialProfile:(NSString *)type{
    [[UserData shareInstance] cancelSocial:type];
}

#pragma mark - Notification

-(void)settingsDidChange:(NSNotification*)notification{
    
    if ([notification.userInfo.allKeys.firstObject isEqual:SET_EDIT_AVATAR]) {
        UIImage *chooseImage = (UIImage *)[[notification.userInfo mutableCopy] objectForKey:SET_EDIT_AVATAR];
        [[UserData shareInstance] setUserAvatarImg:chooseImage];
        
        ///Add to profile change dict
        // [_userProfileChanges setObject:chooseImage forKey:KeyAPI_AVATAR];
    }else if ([notification.userInfo.allKeys.firstObject isEqual:SET_EDIT_USER_NAME]) {
        NSString *username = [[notification.userInfo mutableCopy] objectForKey:SET_EDIT_USER_NAME];
        _cur_userName = username;
        ///Add to profile change dict
        [_userProfileChanges setObject:username forKey:KeyAPI_USERNAME_NAME];
        
    }else if ([notification.userInfo.allKeys.firstObject isEqual:SET_EDIT_EMAIL]){
        NSString *userEmail = [[notification.userInfo mutableCopy] objectForKey:SET_EDIT_EMAIL];
        
        ///Add to profile change dict
        //        [_userProfileChanges setObject:userEmail forKey:KeyAPI_EMAIL];
        _cur_userEmail = userEmail;
        
//        [[UserData shareInstance] setUserEmail:userEmail];
        
    }else if ([notification.userInfo.allKeys.firstObject isEqual:SET_EDIT_GENDER]){
        NSInteger gender = [[[notification.userInfo mutableCopy] objectForKey:SET_EDIT_GENDER] integerValue];
        
        _cur_gender = gender;
        
        ///Add to profile change dict
//        [_userProfileChanges setObject:@(gender) forKey:KeyAPI_GENDER];
//        
//        [[UserData shareInstance] setUserGender:gender];
        
    }else if([notification.userInfo.allKeys.firstObject isEqual:SET_EDIT_PROVINCE]){
        NSString *provine = [notification.userInfo objectForKey:SET_EDIT_PROVINCE];
        ///Add to profile change dict
        _cur_province = provine;
//        [_userProfileChanges setObject:provine forKey:KeyAPI_ADDRESS];
//        [[UserData shareInstance] setUserProvine:provine];
    }else if ([notification.userInfo.allKeys.firstObject isEqual:SETTINGS_KeyUserInstaAccessToken]){
        //TODO: send instagram token
        NSMutableDictionary *socialProfile = [notification.userInfo objectForKey:SETTINGS_KeyUserInstaAccessToken];
        ///Add to social change dict
        NSLog(@"INSTAGRAM profile = %@", socialProfile);
        [[UserData shareInstance] updateSocialSetting:socialProfile];
    }else if ([notification.userInfo.allKeys.firstObject isEqual:SET_EDIT_FACEBOOK]){
        NSString *status = [notification.userInfo objectForKey:SET_EDIT_FACEBOOK];
        [[UserData shareInstance] setFacebookStatus:status];
    }else if ([notification.userInfo.allKeys.firstObject isEqual:SET_EDIT_TWITTER]){
        NSString *status = [notification.userInfo objectForKey:SET_EDIT_TWITTER];
        [[UserData shareInstance] setTwitterStatus:status];
    }else if ([notification.userInfo.allKeys.firstObject isEqual:SET_EDIT_INSTAGRAM]){
        NSString *status = [notification.userInfo objectForKey:SET_EDIT_INSTAGRAM];
        [[UserData shareInstance] setInstagramStatus:status];
    }
    [self.tableView reloadData];
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
            if (!_cur_userName) {
                if (username && ![username isEqualToString:@""]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SET_EDIT_USER_NAME :username}];
                }
            }else{
                if (username && ![username isEqualToString:_cur_userName]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SET_EDIT_USER_NAME :username}];
                }
            }
        }
            break;
        case USEREMAIL_TAG:{
            NSString *userEmail = textField.text;
            if (!_cur_userEmail) {
                if (userEmail && ![userEmail isEqualToString:@""]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SET_EDIT_EMAIL:userEmail}];
                }
            }else{
                if (userEmail && ![userEmail isEqualToString:_cur_userEmail]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SET_EDIT_EMAIL:userEmail}];
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //MALE
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SET_EDIT_GENDER:@"0"}];
    }else if (buttonIndex == 1){
        //FEMALE
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SET_EDIT_GENDER:@"1"}];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [_imagePickerController dismissViewControllerAnimated:YES completion:nil];
    UIImage *chooseImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    if (chooseImage) {
        UIImage *updateImage = [chooseImage fixOrientation];
        if (updateImage) {
            [_userProfileChanges setObject:updateImage forKey:KeyAPI_AVATAR];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SET_EDIT_AVATAR:updateImage}];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
