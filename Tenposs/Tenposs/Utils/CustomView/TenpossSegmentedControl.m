//
//  TenpossSegmentedControl.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossSegmentedControl.h"
#import "HexColors.h"

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
        self.thumbView = [UIView new];
        [self setItems:[NSMutableArray arrayWithObjects:@"Description",@"Size",nil]];
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.labels = [NSMutableArray new];
        self.thumbView = [UIView new];
        [self setItems:[NSMutableArray arrayWithObjects:@"Description",@"Size",nil]];
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    self.layer.cornerRadius = 5;
    
    self.backgroundColor = [UIColor clearColor];
    
    [self setupLabels];
    
    [self insertSubview:_thumbView atIndex:0];
}

- (void)setItems:(NSMutableArray<NSString *> *)items{
    _items = items;
    [self setupLabels];
}

- (void)setupLabels{
    for (UILabel *label in _labels) {
        [label removeFromSuperview];
    }
    
    [_labels removeAllObjects];
    
    for (int i = 0; i < [_items count]; i ++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.text = _items[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#b8b8b8"];
        [self addSubview:label];
        [_labels addObject:label];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    [self displayNewSelectedIndex];
}

- (void)displayNewSelectedIndex{
    UILabel *label = _labels[_selectedIndex];
    for(int i = 0 ; i < [_labels count]; i++){
        UILabel *label = _labels[i];
        if (i == _selectedIndex) {
            [label setTextColor:[UIColor colorWithHexString:@"#18C1BF"]];
        }else{
            [label setTextColor:[UIColor colorWithHexString:@"#b8b8b8"]];
        }
    }
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
    _thumbView.backgroundColor = [UIColor whiteColor];
    _thumbView.layer.cornerRadius = 5;
    
    CGFloat labelHeight = self.bounds.size.height;
    CGFloat labelWidth = self.bounds.size.width/(CGFloat)[_labels count];
    
    for(int i = 0 ; i < [_labels count]; i++){
        UILabel *label = _labels[i];
        if (i == _selectedIndex) {
            [label setTextColor:[UIColor colorWithHexString:@"#18C1BF"]];
        }
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
        [self setSelectedIndex:calculatedIndex];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    return NO;
}

@end
