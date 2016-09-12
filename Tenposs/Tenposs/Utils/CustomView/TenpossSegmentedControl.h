//
//  TenpossSegmentedControl.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface TenpossSegmentedControl : UIControl

- (void)setItems:(NSMutableArray<NSString *> *)items;
- (void)setSelectedIndex:(NSInteger)selectedIndex;

@end
