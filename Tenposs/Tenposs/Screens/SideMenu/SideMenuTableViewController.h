//
//  SideMenuTableViewController.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConfiguration.h"

@interface SideMenuTableViewController : UITableViewController

- (void) setData:(NSMutableArray<MenuModel *> *)menuData;

@end
