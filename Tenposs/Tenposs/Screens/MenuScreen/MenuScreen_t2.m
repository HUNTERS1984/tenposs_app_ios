//
//  MenuScreen_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "MenuScreen_t2.h"
#import "MenuScreenDataSource_t2.h"
#import "HexColors.h"
#import "UIFont+Themify.h"
#import "AppConfiguration.h"
#import "UIViewController+LoadingView.h"

@interface MenuScreen_t2()

@property (strong, nonatomic) MenuScreenDataSource_t2 *mainDataSource;

@end

@implementation MenuScreen_t2

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self showLoadingViewWithMessage:@""];
    
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
    
    if (!_mainDataSource) {
        _mainDataSource = [[MenuScreenDataSource_t2 alloc] init];
        if (!self.navigationController) {
            _mainDataSource.mainNavigationController = _mainNavigationController;
        }else{
            _mainDataSource.mainNavigationController = self.navigationController;
        }
    }
    
    __weak MenuScreen_t2 *weakSelf = self;
    [_mainDataSource fetchDataWithCompleteHandler:^(NSError *error) {
        if (error) {
            [self handleDataSourceError:error];
        }else{
            weakSelf.dataSource = _mainDataSource;
            weakSelf.delegate = _mainDataSource;
            [weakSelf reloadData];
        }
        [self removeAllInfoView];
    }];
    
    self.indicatorColor = [UIColor colorWithHexString:@"3CB963"];
    self.tabsViewBackgroundColor = [UIColor whiteColor];
    self.contentViewBackgroundColor = [UIColor whiteColor];
    self.selectedTextColor = [UIColor colorWithHexString:@"3CB963"];
    self.unSelectedTextColor = [UIColor colorWithHexString:@"999999"];
}

-(void)didPressBackButton{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSString *)title{
    return @"メニュー";
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)handleDataSourceError:(NSError *)error{
    if (!error) {
        [self removeLoadingView];
        return;
    }
    [self removeLoadingView];
    NSString *message = @"Unknow Error";
    switch (error.code) {
        case ERROR_DATASOURCE_NO_CONTENT:
            //TODO: need localize
            message = NSLocalizedString(@"NO CONTENT",nil);
            [self showErrorScreen:message];
            break;
        case ERROR_DETAIL_DATASOURCE_NO_CONTENT:
            message = NSLocalizedString(@"NO CONTENT",nil);
            [self showErrorScreen:message];
            break;
        case ERROR_CONTENT_FULLY_LOADED:
            break;
        case ERROR_DETAIL_DATASOURCE_IS_LAST:{
        }break;
            
        case ERROR_DETAIL_DATASOURCE_IS_FIRST:{
        }break;
        default:
            break;
    }
}

@end
