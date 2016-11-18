//
//  Item_Cell_Top_t2.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/3/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "Common_Item_Cell.h"

@interface Item_Cell_Top_t2 : Common_Item_Cell <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *couponButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *navigateButton;

@end
