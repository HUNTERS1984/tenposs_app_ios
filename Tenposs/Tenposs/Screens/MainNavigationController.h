//
//  MainNavigationController.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TEMPLATE_1  1

@interface MainNavigationController : UINavigationController

@property (strong, nonatomic) UIViewController *rootViewController;

- (instancetype)initWithTemplateId:(NSInteger)templateId;

- (void)toogleMenu;

@end
