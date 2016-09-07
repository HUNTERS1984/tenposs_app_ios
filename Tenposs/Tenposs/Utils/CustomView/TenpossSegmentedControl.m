//
//  TenpossSegmentedControl.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossSegmentedControl.h"

@interface TenpossSegmentedControl()

@property (strong, nonatomic) NSMutableArray<UILabel *> *labels;
@property (strong, nonatomic) NSMutableArray<NSString *> *items;
@property (assign, nonatomic) NSInteger selectedIndex;
@property UIView *thumbView;
@end

@implementation TenpossSegmentedControl

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.labels = [NSMutableArray new];
        [self setItems:[NSMutableArray arrayWithObjects:@"item 1",@"item 2",@"item 3",nil]];
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.labels = [NSMutableArray new];
        [self setItems:[NSMutableArray arrayWithObjects:@"item 1",@"item 2",@"item 3",nil]];
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.borderWidth = 1;
    
    self.backgroundColor = [UIColor lightGrayColor];
    
    [self setupLabels];
    
    [self insertSubview:_thumbView atIndex:0];
}

- (void)setItems:(NSMutableArray<NSString *> *)items{
    [self setupLabels];
}

- (void)setupLabels{
    for (UILabel *label in _labels) {
        [label removeFromSuperview];
    }
    
    [_labels removeAllObjects];
    
    for (int i = 0; i < [_items count]; i ++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.text = _items[i -1];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        [self addSubview:label];
        [_labels addObject:label];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    [self displayNewSelectedIndex];
}

- (void)displayNewSelectedIndex{
    UILabel *label =_labels[_selectedIndex];
    self.thumbView.frame = label.frame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect selectFrame = self.bounds;
    
    CGFloat newWidth = CGRectGetWidth(selectFrame) / (CGFloat)[_items count];
    
    selectFrame.size.width = newWidth;
    
    _thumbView.frame = selectFrame;
    _thumbView.backgroundColor = [UIColor greenColor];
    _thumbView.layer.cornerRadius = 5;
    
    CGFloat labelHeight = self.bounds.size.height;
    CGFloat labelWidth = self.bounds.size.width/(CGFloat)[_labels count];
    
    for(int i = 0 ; i < [_labels count]; i++){
        UILabel *label = _labels[i];
        CGFloat xPosition = (CGFloat) (i * labelWidth);
        label.frame = CGRectMake(xPosition, 0, labelWidth, labelHeight);
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:self];
    NSInteger calculatedIndex = -1;
    for (int i = 0 ; i < [_labels count]; i++) {
        UILabel *label = _labels[i];
        if (CGRectContainsPoint(label.frame, location)) {
            calculatedIndex = i;
        }
    }
    if (calculatedIndex != -1) {
        _selectedIndex = calculatedIndex;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    return NO;
}

@end
