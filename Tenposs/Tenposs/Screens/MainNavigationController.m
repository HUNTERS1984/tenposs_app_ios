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

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (instancetype)initWithTemplateId:(NSInteger)templateId{
    if (templateId == TEMPLATE_1) {
        self.rootViewController = [[GrandViewController alloc]init];
    }
    
    self = [super initWithRootViewController:self.rootViewController];
    
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
