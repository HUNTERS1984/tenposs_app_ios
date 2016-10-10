//
//  Item_Detail_Header_Segmented.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item_Detail_Common.h"
#import "TenpossSegmentedControl.h"

@interface Item_Detail_Header_Segmented : Item_Detail_Common

@property (weak, nonatomic) IBOutlet UIView *segmentControlWrapper;
@property (weak, nonatomic) IBOutlet TenpossSegmentedControl *segmentControl;

@end
