//
//  MenuItem_Common.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/27/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "AppConfiguration.h"

@interface MenuItem_Common : UITableViewCell
- (void)configureCellWithData:(MenuModel *)data;
@end
