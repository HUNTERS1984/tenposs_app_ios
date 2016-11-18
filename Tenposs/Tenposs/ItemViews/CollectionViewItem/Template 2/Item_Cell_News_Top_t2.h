//
//  Item_Cell_News_Top_t2.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/13/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common_Item_Cell.h"

@interface Item_Cell_News_Top_t2 : Common_Item_Cell <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
