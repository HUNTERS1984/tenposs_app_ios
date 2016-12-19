//
//  SignUpScreenNext_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/3/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SignUpScreenNext_t2.h"
#import "AppConfiguration.h"
#import "HexColors.h"
#import "UIFont+Themify.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "AuthenticationManager.h"
#import "UserData.h"
#import "UIView+LoadingView.h"

@interface SignUpScreenNext_t2 ()<UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *invitationCodeText;
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@property (weak, nonatomic) IBOutlet UIButton *provinceButton;
@property (weak, nonatomic) IBOutlet UIButton *yearButton;
@property (weak, nonatomic) IBOutlet UIButton *genderButton;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *dimBackground;

@property (strong, nonatomic) NSMutableArray *years;
@property (strong, nonatomic) NSMutableArray *provinces;
@property (strong, nonatomic) NSMutableArray *pickerDataArray;

@property (weak, nonatomic) id currentPickerSource;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation SignUpScreenNext_t2

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.view layoutIfNeeded];
    
    _contentView.layer.cornerRadius = 5;
    _contentView.clipsToBounds = YES;
    
    _signUpButton.layer.cornerRadius = 5;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self togglePicker:NO];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    if (self.navigationController) {
        //TODO: this has been presented by SignUpScreen
        
    }else{
        //TODO: this has been presented by Social Login
        
    }
}

- (void)hideKeyBoard{
    [_invitationCodeText resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender{
    if (sender == _provinceButton) {
        //TODO: show province chooser
        [self toggleProvincePicker];
    }else if (sender == _yearButton){
        //TODO: show year chooser
        [self toggleYearPicker];
    }else if (sender == _genderButton){
        [self toggleGenderSelect];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *settings = [appConfig getAvailableAppSettings];
    
    if ([[self.navigationController viewControllers] count] > 1) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(didPressBackButton)];
        self.navigationItem.leftBarButtonItem = backButton;
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.navigationItem setBackBarButtonItem:nil];
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                       [UIFont themifyFontOfSize:20/*[UIUtils getTextSizeWithType:settings.font_size]*/], NSFontAttributeName,
                                                                       [UIColor colorWithHexString:@"ffffff"], NSForegroundColorAttributeName,
                                                                       nil]
                                                             forState:UIControlStateNormal];
        [self.navigationItem.leftBarButtonItem setTitle:[NSString stringWithFormat: @"%@", [UIFont stringForThemifyIdentifier:@"ti-angle-left"]]];
    }
}

- (void)didPressBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signUpTouch:(id)sender {
    if (self.navigationController) {
        //This is for SignUp
        [self doRegister];
    }else{
        //This is for update user data after signup with social account
        [self doUpdateUserInfo];
    }
}

- (IBAction)doneTogglePicker:(id)sender {
    [self togglePicker:NO];
}

- (void)doRegister{
    [SVProgressHUD show];
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
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate registerPushNotification];
    [self showTop];
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
                      @"hokkaido",
                      @"aomori",
                      @"iwate",
                      @"miyagi",
                      @"akita",
                      @"yamagata",
                      @"fukushima",
                      @"ibaraki",
                      @"tochigi",
                      @"gunma",
                      @"saitama",
                      @"chiba",
                      @"tokyo",
                      @"kanagawa",
                      @"niigata",
                      @"toyama",
                      @"ishikawa",
                      @"fukui",
                      @"yamanashi",
                      @"nagano",
                      @"gifi",
                      @"shizouka",
                      @"aichi",
                      @"mie",
                      @"shiga",
                      @"kyoto",
                      @"osaka",
                      @"hyogo",
                      @"nara",
                      @"wakayama",
                      @"tottori",
                      @"shimane",
                      @"okayama",
                      @"hiroshima",
                      @"yamaguchi",
                      @"tokushima",
                      @"kagawa"   ,
                      @"ehime"    ,
                      @"kochi"    ,
                      @"fukuoka"  ,
                      @"saga"     ,
                      @"nagasaki" ,
                      @"kumamoto" ,
                      @"oita"     ,
                      @"miyazaki" ,
                      @"kogoshima",
                      @"okinawa",
                      nil];
    }
    
    _currentPickerSource = _provinceButton;
    _pickerDataArray = _provinces;
    [_picker reloadAllComponents];
    
    [self togglePicker:YES];
    
    NSString *currentProvince = _provinceLabel.text;
    if ([currentProvince containsString:@"Select"]) {
        return;
    }else{
        NSInteger currentIndex = [_provinces indexOfObject:currentProvince];
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
        [_yearLabel setText:[_pickerDataArray objectAtIndex:row]];
    }else if (_currentPickerSource == _provinceButton){
        [_provinceLabel setText:[_pickerDataArray objectAtIndex:row]];
    }
}

#pragma mark - ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //MALE
        [_genderLabel setText:NSLocalizedString(@"gender_male",nil)];
    }else if (buttonIndex == 1){
        //FEMALE
        [_genderLabel setText:NSLocalizedString(@"gender_female",nil)];
    }
}


@end
