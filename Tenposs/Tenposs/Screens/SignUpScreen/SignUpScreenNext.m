//
//  SignUpScreenNext.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/28/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SignUpScreenNext.h"
#import "AuthenticationManager.h"
#import "UserData.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"

@interface SignUpScreenNext ()<UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *invitationCodeText;
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@property (weak, nonatomic) IBOutlet UIButton *provinceButton;
@property (weak, nonatomic) IBOutlet UIButton *yearButton;
@property (weak, nonatomic) IBOutlet UIButton *genderButton;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *dimBackground;

@property (strong, nonatomic) NSMutableArray *years;
@property (strong, nonatomic) NSMutableArray *provinces;
@property (strong, nonatomic) NSMutableArray *pickerDataArray;
@property (strong, nonatomic) NSMutableDictionary *userProfileChanges;
@property (assign, nonatomic) NSInteger cur_gender;
@property (strong, nonatomic) NSString *cur_province;
@property (strong, nonatomic) NSString *cur_birthday;

@property (weak, nonatomic) id currentPickerSource;

@end

@implementation SignUpScreenNext

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self togglePicker:NO];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    
    [self.view addGestureRecognizer:tapGesture];
    _cur_gender = -1;
    _cur_birthday = @"";
    _cur_province = @"";
    if (self.signUpData) {
        //TODO: this has been presented by SignUpScreen
        
    }else{
        _userProfileChanges = [NSMutableDictionary new];
        //TODO: this has been presented by Social Login
        
    }
}

- (NSString *)title{
    return @"新規会員登録 (2/2)";
}

- (void)hideKeyBoard{
    [_invitationCodeText resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender{
    if (sender == _provinceButton) {
        //TODO: show province chooser
        [self toggleProvincePicker];
    }else if (sender == _yearButton){
        //TODO: show year chooser
        [self toggleYearPicker];
    }else if (sender == _signinButton){
        //TODO: do login
        if (self.signUpData) {
            //This is for SignUp
            [self doRegister];
        }else{
            //This is for update user data after signup with social account
            [self doUpdateUserInfo];
        }
        
    }else if (sender == _genderButton){
        [self toggleGenderSelect];
    }
}

- (IBAction)doneTogglePicker:(id)sender {
    [self togglePicker:NO];
}

- (void)doRegister{
    [SVProgressHUD show];
    if (![_invitationCodeText.text isEqualToString:@""])
        [_signUpData setObject:_invitationCodeText.text forKey:KeyAPI_CODE];
    else
        [_signUpData removeObjectForKey:KeyAPI_CODE];
    
    if (![_cur_province isEqualToString:@""])
        [_signUpData setObject:_cur_province forKey:KeyAPI_ADDRESS];
    else
        [_signUpData removeObjectForKey:KeyAPI_ADDRESS];
    
    if (![_cur_birthday isEqualToString:@""])
        [_signUpData setObject:_cur_birthday forKey:KeyAPI_BIRTHDAY];
    else
        [_signUpData removeObjectForKey:KeyAPI_BIRTHDAY];
    
    if (_cur_gender >= 0)
        [_signUpData setObject:[@(_cur_gender) stringValue] forKey:KeyAPI_GENDER];
    else
        [_signUpData removeObjectForKey:KeyAPI_GENDER];
    
    
    [[AuthenticationManager sharedInstance] AuthSignUpWithEmail:_signUpData andCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
        NSMutableDictionary *resultDic;
        if ([resultData isKindOfClass:[CommonResponse class]]) {
            resultDic = [((CommonResponse *)resultData).data mutableCopy];
        }else{
            resultDic = [resultData mutableCopy];
        }
        if(isSuccess){
            NSMutableDictionary *userData = [resultDic mutableCopy];
            NSMutableDictionary *tokenKit = [[NSMutableDictionary alloc] init];
            if ([userData objectForKey:@"token"]) {
                [tokenKit setObject:[userData objectForKey:@"token"] forKey:@"token"];
                [userData removeObjectForKey:@"token"];
            }
            if ([userData objectForKey:@"refresh_token"]) {
                [tokenKit setObject:[userData objectForKey:@"refresh_token"] forKey:@"refresh_token"];
                [userData removeObjectForKey:@"refresh_token"];
            }
            if ([userData objectForKey:@"access_refresh_token_href"]) {
                [tokenKit setObject:[userData objectForKey:@"access_refresh_token_href"] forKey:@"access_refresh_token_href"];
                [userData removeObjectForKey:@"access_refresh_token_href"];
            }
            
            [UserData shareInstance].userDataDictionary = [userData mutableCopy];
            [[UserData shareInstance] saveUserData];
            [[UserData shareInstance] saveTokenKit:[tokenKit copy]];
            
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [delegate registerPushNotification];
            
            [self showTop];
            
        }else{
            [self showAlertView:@"エラー" message:@"新規会員登録できません"];
        }
        [SVProgressHUD dismiss];
    }];
}

- (void)doUpdateUserInfo{
    //TODO: Update profile after signIn with social account
    [_userProfileChanges setObject:[UserData shareInstance].getUserEmail forKey:KeyAPI_EMAIL];
    
    if (![_invitationCodeText.text isEqualToString:@""])
        [_userProfileChanges setObject:_invitationCodeText.text forKey:KeyAPI_CODE];
    else
        [_userProfileChanges removeObjectForKey:KeyAPI_CODE];
    
    if (![_cur_province isEqualToString:@""])
        [_userProfileChanges setObject:_cur_province forKey:KeyAPI_ADDRESS];
    else
        [_userProfileChanges removeObjectForKey:KeyAPI_ADDRESS];
    
    if (![_cur_birthday isEqualToString:@""])
        [_userProfileChanges setObject:_cur_birthday forKey:KeyAPI_BIRTHDAY];
    else
        [_userProfileChanges removeObjectForKey:KeyAPI_BIRTHDAY];
    
    if (_cur_gender >= 0)
        [_userProfileChanges setObject:[@(_cur_gender) stringValue] forKey:KeyAPI_GENDER];
    else
        [_userProfileChanges removeObjectForKey:KeyAPI_GENDER];
    
    
    [[AuthenticationManager sharedInstance] AuthUpdateProfileAfterSocialSignUp:[_userProfileChanges mutableCopy] andCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
        NSMutableDictionary *resultDic;
        if ([resultData isKindOfClass:[CommonResponse class]]) {
            resultDic = [((CommonResponse *)resultData).data mutableCopy];
        }else{
            resultDic = [resultData mutableCopy];
        }
        if(isSuccess){
            [[AuthenticationManager sharedInstance] AuthGetUserProfileWithCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
                NSMutableDictionary *resultDict;
                if([resultData isKindOfClass:[CommonResponse class]]){
                    CommonResponse *result = (CommonResponse *)resultData;
                    resultDict = result.data;
                }else{
                    resultDict = [resultData mutableCopy];
                }
                if (isSuccess) {
                    NSMutableDictionary *userData = [resultDict objectForKey:@"user"];
                    [UserData shareInstance].userDataDictionary = [userData mutableCopy];
                    [[UserData shareInstance] saveUserData];
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_USER_PROFILE_UPDATED object:nil userInfo:@{@"status":@"success"}];
                    
                    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                    [delegate registerPushNotification];
                    [self showTop];
                }else{
                    
                }
            }];
            
        }else{
            [self showAlertView:@"エラー" message:@"新規会員登録できません"];
        }
        [SVProgressHUD dismiss];
    }];
    
}

- (void)togglePicker:(BOOL)show{
    __weak UIView *weakDim = _dimBackground;
    __weak UIView *weakPick = _pickerView;

    if (show) {
        [_dimBackground setHidden:NO];
        
        [UIView animateWithDuration:.35
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [weakPick setHidden:NO];
                         }
                         completion:^(BOOL finished){}];
    }else{
        [_dimBackground setHidden:NO];
        
        [UIView animateWithDuration:.35
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                         }
                         completion:^(BOOL finished){
                             [weakPick setHidden:YES];
                             [weakDim setHidden:YES];
                         }];
    }
}

- (void)toggleProvincePicker{
    if(!_provinces){
        _provinces = [NSMutableArray arrayWithObjects:
                     NSLocalizedString(@"hokkaido",nil),
                     NSLocalizedString(@"aomori",nil),
                     NSLocalizedString(@"iwate",nil),
                     NSLocalizedString(@"miyagi",nil),
                     NSLocalizedString(@"akita",nil),
                     NSLocalizedString(@"yamagata",nil),
                     NSLocalizedString(@"fukushima",nil),
                     NSLocalizedString(@"ibaraki",nil),
                     NSLocalizedString(@"tochigi",nil),
                     NSLocalizedString(@"gunma",nil),
                     NSLocalizedString(@"saitama",nil),
                     NSLocalizedString(@"chiba",nil),
                     NSLocalizedString(@"tokyo",nil),
                     NSLocalizedString(@"kanagawa",nil),
                     NSLocalizedString(@"niigata",nil),
                     NSLocalizedString(@"toyama",nil),
                     NSLocalizedString(@"ishikawa",nil),
                     NSLocalizedString(@"fukui",nil),
                     NSLocalizedString(@"yamanashi",nil),
                     NSLocalizedString(@"nagano",nil),
                     NSLocalizedString(@"gifi",nil),
                     NSLocalizedString(@"shizouka",nil),
                     NSLocalizedString(@"aichi",nil),
                     NSLocalizedString(@"mie",nil),
                     NSLocalizedString(@"shiga",nil),
                     NSLocalizedString(@"kyoto",nil),
                     NSLocalizedString(@"osaka",nil),
                     NSLocalizedString(@"hyogo",nil),
                     NSLocalizedString(@"nara",nil),
                     NSLocalizedString(@"wakayama",nil),
                     NSLocalizedString(@"tottori",nil),
                     NSLocalizedString(@"shimane",nil),
                     NSLocalizedString(@"okayama",nil),
                     NSLocalizedString(@"hiroshima",nil),
                     NSLocalizedString(@"yamaguchi",nil),
                     NSLocalizedString(@"tokushima",nil),
                     NSLocalizedString(@"kagawa",nil),
                     NSLocalizedString(@"ehime",nil),
                     NSLocalizedString(@"kochi",nil),
                     NSLocalizedString(@"fukuoka",nil),
                     NSLocalizedString(@"saga",nil),
                     NSLocalizedString(@"nagasaki",nil),
                     NSLocalizedString(@"kumamoto",nil),
                     NSLocalizedString(@"oita",nil),
                     NSLocalizedString(@"miyazaki",nil),
                     NSLocalizedString(@"kogoshima",nil),
                     NSLocalizedString(@"okinawa",nil),
                     nil];
    }
    
    _currentPickerSource = _provinceButton;
    _pickerDataArray = _provinces;
    [_picker reloadAllComponents];
    
    [self togglePicker:YES];
    
    self.cur_province = _provinceLabel.text;
    if ([self.cur_province containsString:@"都道府県"]) {
        return;
    }else{
        NSInteger currentIndex = [_provinces indexOfObject:self.cur_province];
        [_picker selectRow:currentIndex inComponent:0 animated:YES];
    }
}

- (void)toggleYearPicker{
    if (!_years) {
        //Get Current Year into i2
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        int i2  = [[formatter stringFromDate:[NSDate date]] intValue];
        
        //Create Years Array from 1960 to This year
        _years = [[NSMutableArray alloc] init];
        for (int i=1960; i<=i2; i++) {
            [_years addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    _currentPickerSource = _yearButton;
    _pickerDataArray = _years;
    [_picker reloadAllComponents];
    
    [self togglePicker:YES];
    
    NSString *currentYearString = _yearLabel.text;
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    BOOL isDecimal = [nf numberFromString:currentYearString] != nil;
    if (isDecimal) {
        NSInteger currentIndex = [_years indexOfObject:currentYearString];
        [_picker selectRow:currentIndex inComponent:0 animated:YES];
    }
}

- (void)toggleGenderSelect{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:NSLocalizedString(@"gender",nil)
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:NSLocalizedString(@"gender_male",nil),NSLocalizedString(@"gender_female",nil)
                                  ,nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];

}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _pickerDataArray?[_pickerDataArray count]:0;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_pickerDataArray objectAtIndex:row];
}

#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(_currentPickerSource == _yearButton){
        self.cur_birthday = [_pickerDataArray objectAtIndex:row];
        [_yearLabel setText:self.cur_birthday];
    }else if (_currentPickerSource == _provinceButton){
        self.cur_province = [_pickerDataArray objectAtIndex:row];
        [_provinceLabel setText:self.cur_province];
    }
}

#pragma mark - ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //MALE
        [_genderLabel setText:NSLocalizedString(@"gender_male",nil)];
        self.cur_gender = 0;
    }else if (buttonIndex == 1){
        //FEMALE
        [_genderLabel setText:NSLocalizedString(@"gender_female",nil)];
        self.cur_gender = 1;
    }
}

@end
