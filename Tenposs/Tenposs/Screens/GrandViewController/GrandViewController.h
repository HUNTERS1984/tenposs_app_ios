//
//  GrandViewController.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/9/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideMenuTableViewController.h"
#import "BaseViewController.h"

@interface GrandViewController : BaseViewController<SideMenuDelegate>
- (void)performSegueWithObject:(NSObject *)object;
@end
