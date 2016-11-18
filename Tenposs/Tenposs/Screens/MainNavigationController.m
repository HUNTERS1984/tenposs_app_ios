//
//  MainNavigationController.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "MainNavigationController.h"
#import "TopScreen.h"
#import "GrandViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "SideMenuTableViewController.h"
#import "UIUtils.h"
#import "NewsDetailScreen.h"

@interface MainNavigationController () <UINavigationControllerDelegate>

@end

@implementation MainNavigationController

- (instancetype)initWithTemplateId:(NSInteger)templateId{
    //if (templateId == TEMPLATE_1) {
        self.rootViewController = [[UIUtils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([GrandViewController class])];
    //}
    
    self = [super initWithRootViewController:self.rootViewController];
    
    if (self) {
        self.delegate = self;
    }
    
    return self;
}

- (void)toogleMenu{
    if ([self.parentViewController isKindOfClass:[MFSideMenuContainerViewController class]]) {
        [((MFSideMenuContainerViewController *)self.parentViewController) toggleLeftSideMenuCompletion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if([self.viewControllers count] > 1){
        [((MFSideMenuContainerViewController *)self.parentViewController) setPanMode:MFSideMenuPanModeNone];
    }else{
        [((MFSideMenuContainerViewController *)self.parentViewController) setPanMode:MFSideMenuPanModeDefault];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
}


@end
