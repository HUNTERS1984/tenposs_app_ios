//
//  Item_Staff_Table_t2.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common_Table_Cell.h"

@interface Item_Staff_Table_t2 : Common_Table_Cell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@end
