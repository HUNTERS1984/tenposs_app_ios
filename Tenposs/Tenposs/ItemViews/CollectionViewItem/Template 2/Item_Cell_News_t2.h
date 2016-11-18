//
//  Item_Cell_News_t2.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common_Item_Cell.h"

@interface Item_Cell_News_t2 : Common_Item_Cell

@property (weak, nonatomic) IBOutlet UIImageView *thumb;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end
