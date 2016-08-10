//
//  MainNavigationController.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "MainNavigationController.h"
#import "TopScreen.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (instancetype)initWithTemplateId:(NSInteger)templateId{
    UIViewController *rootViewController = nil;
    if (templateId == TEMPLATE_1) {
        rootViewController = [[TopScreen alloc]initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
        ((TopScreen *)rootViewController).mainNavigationController = self;
    }
    
    self = [super initWithRootViewController:rootViewController];
    
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
