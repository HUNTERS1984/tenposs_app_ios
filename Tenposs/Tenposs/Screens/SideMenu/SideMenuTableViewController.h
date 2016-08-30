//
//  SideMenuTableViewController.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConfiguration.h"

@protocol SideMenuDelegate <NSObject>

- (void)didSelectSideMenuItem:(NSObject *)item;

@end

@interface SideMenuTableViewController : UITableViewController

@property(weak, nonatomic) id<SideMenuDelegate> delegate;

- (void) setData:(NSArray<MenuModel *> *)menuData;

@end
