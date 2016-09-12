//
//  SettingsProvineScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/12/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SettingsProvineScreen.h"
#import "Const.h"
#import <InAppSettingsKit/IASKSettingsReader.h>

@interface SettingsProvineScreen ()
@property NSMutableArray *provines;
@end

@implementation SettingsProvineScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _provines = [NSMutableArray arrayWithObjects:
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
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged object:self userInfo:@{SETTINGS_KeyUserProvine:_provines[indexPath.row]}];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
