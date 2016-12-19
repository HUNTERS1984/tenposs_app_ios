//
//  SideMenuViewController.h
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/12/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SideMenuDelegate <NSObject>

- (void)didSelectSideMenuItem:(NSObject *)item;

@end

@interface SideMenuViewController : UITableViewController

@property(weak, nonatomic) id<SideMenuDelegate> delegate;

@end
