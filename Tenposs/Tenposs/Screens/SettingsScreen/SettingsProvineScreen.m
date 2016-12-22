//
//  SettingsProvineScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/12/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SettingsProvineScreen.h"
#import "Const.h"
#import "UIFont+Themify.h"
#import "HexColors.h"
#import "AppConfiguration.h"
#import "UIUtils.h"
#import "SettingsEditProfileScreen.h"
#import "UIFont+Themify.h"

@interface SettingsProvineScreen ()
@property NSMutableArray *provines;
@end

@implementation SettingsProvineScreen

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
                                                                       [UIFont themifyFontOfSize:20/*[UIUtils getTextSizeWithType:settings.font_size]*/], NSFontAttributeName,
                                                                       [UIColor colorWithHexString:settings.title_color], NSForegroundColorAttributeName,
                                                                       nil]
                                                             forState:UIControlStateNormal];
        [self.navigationItem.leftBarButtonItem setTitle:[NSString stringWithFormat: @"%@", [UIFont stringForThemifyIdentifier:@"ti-angle-left"]]];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                         [UIColor colorWithHexString:settings.title_color], NSForegroundColorAttributeName,nil]];
    }
    
    _provines = [NSMutableArray arrayWithObjects:
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
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    
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
        [self.navigationItem.leftBarButtonItem setTitle:[NSString stringWithFormat: [UIFont stringForThemifyIdentifier:@"ti-angle-left"]]];
    }
    
}

- (NSString *)title{
    return @"都道府県";
}

- (void)didPressBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_provines count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    if (cell) {
        cell.textLabel.text = NSLocalizedString(_provines[indexPath.row], nil);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SET_EDIT_CHANGED object:self userInfo:@{SET_EDIT_PROVINCE:_provines[indexPath.row]}];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
