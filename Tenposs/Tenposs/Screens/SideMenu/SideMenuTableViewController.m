//
//  SideMenuTableViewController.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SideMenuTableViewController.h"
#import "AppConfiguration.h"
#import "HexColors.h"
#import "MenuItem_Common.h"
#import "MenuItem_User.h"
#import "DataModel.h"
#import "MFSideMenuContainerViewController.h"

@interface SideMenuTableViewController ()

@property (strong, nonatomic) NSArray<MenuModel *> *menuArray;
@property (assign, nonatomic) NSInteger shouldSelectIndex;
@property (strong, nonatomic) NSObject *currentMenuItem;
@end

@implementation SideMenuTableViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.shouldSelectIndex = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *setting = [appConfig getAvailableAppSettings];
    
    if (setting && setting.menu_background_color != nil && ![setting.menu_background_color isEqualToString:@""]) {
        self.view.backgroundColor = [UIColor colorWithHexString:setting.menu_background_color];
        self.tableView.backgroundColor = [UIColor colorWithHexString:setting.menu_background_color];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self registerCellClass];
    
    if (_shouldSelectIndex == -1) {
        _shouldSelectIndex = 1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public methods
- (void) setData:(NSArray<MenuModel *> *)menuData{
    _menuArray = menuData;
    [self.tableView reloadData];
    if (_currentMenuItem == nil) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_shouldSelectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:_shouldSelectIndex inSection:0]];
    }
}

- (void) setSelectedItemWithId:(NSInteger)itemId{
    if (!_menuArray || [_menuArray count] <= 0) {
        return;
    }
    NSInteger index = [self indexForItemWithId:itemId];
    if (index != - 1) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - Private methods

- (void)registerCellClass{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MenuItem_Common class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MenuItem_Common class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MenuItem_User class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MenuItem_User class])];
}

- (NSInteger)indexForItemWithId:(NSInteger)itemId{
    NSInteger index = -1;
    for (int i = 0; i < [_menuArray count]; i ++) {
        MenuModel *item = [_menuArray objectAtIndex:i];
        if (item.menu_id == itemId) {
            index = i;
            break;
        }
    }
    return index;
}

#pragma mark - Table view data source

- (NSObject *)itemForIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    if (index == 0) {
        return [UserModel new];
    }else {
        return [_menuArray objectAtIndex:index - 1];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuArray?[self.menuArray count]:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    NSObject *item = [self itemForIndexPath:indexPath];
    
    if ([item isKindOfClass:[MenuModel class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MenuItem_Common class]) forIndexPath:indexPath];
        if (cell) {
            [((MenuItem_Common *)cell) configureCellWithData:(MenuModel *)item];
        }
    }else if ([item isKindOfClass:[UserModel class]]){
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MenuItem_User class]) forIndexPath:indexPath];
        if (cell) {
            [((MenuItem_User *)cell) configureCellWithData:(UserModel *)item];
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *item = [self itemForIndexPath:indexPath];
    if (item) {
        _currentMenuItem = (MenuModel *)item;
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSelectSideMenuItem:)]) {
            [self.delegate didSelectSideMenuItem:item];
        }
    }
    if (self.parentViewController && [self.parentViewController isKindOfClass:  [MFSideMenuContainerViewController class]]){
        [((MFSideMenuContainerViewController *)self.parentViewController) setMenuState:MFSideMenuStateClosed completion:nil];
    }
}

@end