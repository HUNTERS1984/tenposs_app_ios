//
//  TenpossSegmentedControl.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TenpossSegmentControlDelegate <NSObject>

- (void)onChangedToIndex:(NSInteger)index;

@end

IB_DESIGNABLE
@interface TenpossSegmentedControl : UIControl

@property (weak, nonatomic) id<TenpossSegmentControlDelegate> delegate;
@property (assign, nonatomic) NSInteger needUpdateIndex;
@property (strong, nonatomic) NSMutableArray<NSString *> *items;

- (void)setItems:(NSMutableArray<NSString *> *)items;
- (void)setSelectedIndex:(NSInteger)selectedIndex;
- (NSInteger)getSelectedIndex;

@end
