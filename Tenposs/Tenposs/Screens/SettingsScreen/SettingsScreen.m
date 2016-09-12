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

//#import "UserData.h"

#define USERID_TAG 100
#define USERNAME_TAG 101
#define USEREMAIL_TAG 102

@interface SettingsScreen () <UITextFieldDelegate, UIActionSheetDelegate>{
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingDidChange:) name:kIASKAppSettingChanged object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UserData *userData = [UserData shareInstance];
    cur_userId = [userData getUserID];
    cur_userName = [userData getUserName];
    cur_userEmail = [userData getUserEmail];
    _userProfileChanges = [NSMutableDictionary new];
    
    self.settingView = [self appSettingsViewController];
    self.settingView.view.frame = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height);// self.view.bounds;
    [self.view addSubview:self.settingView.view];
    [self addChildViewController:self.settingView];
    [self.settingView didMoveToParentViewController:self];
    //[self.navigationController pushViewController:_settingView animated:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    if ([_userProfileChanges count] > 0) {
        for (NSString *key in _userProfileChanges.allKeys) {
            if ([key isEqualToString:SETTINGS_KeyUserAvatar]) {
                UIImage *image = (UIImage *)[_userProfileChanges objectForKey:key];
                image = [UIUtils scaleImage:image toSize:CGSizeMake(200,200)];
                NSData *imageData = UIImagePNGRepresentation(image);
                [_userProfileChanges setObject:imageData forKey:key];
                break;
            }
        }
        
        [_userProfileChanges setObject:[[UserData shareInstance] getToken] forKey:KeyAPI_TOKEN];
        
        [[NetworkCommunicator shareInstance] POSTWithImage:API_UPDATE_PROFILE parameters:_userProfileChanges onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
            NSLog(@"UPDATE_PROFILE");
            [_userProfileChanges removeAllObjects];
        }];
  
    }

    [super viewWillDisappear:animated];
}

- (SettingsTableViewController*)appSettingsViewController {
    if (!_settingView) {
        _settingView = [[SettingsTableViewController alloc] init];
        _settingView.delegate = self;
        
        ///TODO: open when available
        //UserData *userData = [Userdata sharedInstance];
        //BOOL enabled = [userData getToken]==nil;
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
    return @"Settings";
}

#pragma mark - IASKSettingsDelegate

- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender{
    NSLog(@"Settings did end");
}

- (void)settingDidChange:(NSNotification*)notification {
    if ([notification.userInfo.allKeys.firstObject isEqual:SETTINGS_KeyUserAvatar]) {
        
    }else if ([notification.userInfo.allKeys.firstObject isEqual:SETTINGS_KeyUserAvatar]){
        
    }else if ([notification.userInfo.allKeys.firstObject isEqualToString:SETTINGS_KeyUserGender]){
        NSInteger gender = [[[notification.userInfo mutableCopy] objectForKey:SETTINGS_KeyUserGender] integerValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UserData shareInstance] setUserGender:gender];
            if([self.navigationController.visibleViewController isKindOfClass:[IASKAppSettingsViewController class]]){
                [((IASKAppSettingsViewController *)self.navigationController.visibleViewController).tableView reloadData];
            }
            [self.settingView.tableView reloadData];
        });
    }else if([notification.userInfo.allKeys.firstObject isEqualToString:SETTINGS_KeyUserProvine]){
        NSString *provine = [notification.userInfo objectForKey:SETTINGS_KeyUserProvine];
        [[UserData shareInstance] setUserProvine:provine];
        if([self.navigationController.visibleViewController isKindOfClass:[IASKAppSettingsViewController class]]){
            [((IASKAppSettingsViewController *)self.navigationController.visibleViewController).tableView reloadData];
        }
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
        ((Settings_Avatar *)cell).avatar.clipsToBounds = YES;
        UIImage *ava = [userData getUserAvatarImg];
        if (ava) {
            [((Settings_Avatar *)cell).avatar setImage:ava];
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
        [((Setting_EditText *)cell).text  setPlaceholder:@"User Id"];
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
        [((Setting_EditText *)cell).text  setPlaceholder:@"Username"];
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
        [((Setting_EditText *)cell).text  setPlaceholder:@"Email address"];
        [((Setting_EditText *)cell).text  setText:[userData getUserEmail]];
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
        [((Settings_Expand_Selector *)cell).text  setText:[userData getUserProvine]];
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
    }
    return cell;
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
                                      //TODO: need localize
                                      initWithTitle:@"Select gender"
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Male",@"Female",nil];
        
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
                    [_userProfileChanges setObject:username forKey:KeyAPI_USERNAME_NAME];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged object:self userInfo:@{@"KeyUsername" :username}];
                }
            }else{
                if (username && ![username isEqualToString:cur_userName]) {
                    [_userProfileChanges setObject:username forKey:KeyAPI_USERNAME_NAME];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged object:self userInfo:@{@"KeyUsername" :username}];
                }
            }
        }
            break;
        case USEREMAIL_TAG:{
            NSString *userEmail = textField.text;
            if (!cur_userEmail) {
                if (userEmail && ![userEmail isEqualToString:@""]) {
                    [_userProfileChanges setObject:userEmail forKey:KeyAPI_EMAIL];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged object:self userInfo:@{@"KeyUserEmail" :userEmail}];
                }
            }else{
                if (userEmail && ![userEmail isEqualToString:cur_userEmail]) {
                    [_userProfileChanges setObject:userEmail forKey:KeyAPI_EMAIL];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged object:self userInfo:@{@"KeyUserEmail" :userEmail}];
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
        [_userProfileChanges setObject:chooseImage forKey:SETTINGS_KeyUserAvatar];
        [[UserData shareInstance] setUserAvatarImg:chooseImage];
        [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged object:self userInfo:@{SETTINGS_KeyUserAvatar:chooseImage}];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
