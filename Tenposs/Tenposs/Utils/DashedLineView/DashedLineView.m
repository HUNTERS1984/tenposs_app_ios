//
//  DashedLineView.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/11/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "DashedLineView.h"

@implementation DashedLineView

static CGFloat const kDashedBorderWidth     = (2.0f);
static CGFloat const kDashedPhase           = (0.0f);
static CGFloat const kDashedLinesLength[]   = {4.0f, 4.0f};
static size_t const kDashedCount            = (2.0f);

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
}

- (CGColorRef) dashColor{
    return self.lineColor.CGColor;
}

//- (CGFloat)dashLength{
//    return self
//}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint p0 = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMidY(self.bounds));
    CGContextMoveToPoint(context, p0.x, p0.y);
    
    CGPoint p1 = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds));
    CGContextAddLineToPoint(context, p1.x, p1.y);
    
    CGContextSetLineDash(context, 0.0f, kDashedLinesLength, 2.0f) ;
    
    CGContextSetLineWidth(context, 1.0f);
    
    CGContextSetLineCap(context,kCGLineCapSquare);
    
    [[UIColor colorWithWhite:1.0f alpha:0.5f] set];
    
//    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);

    CGContextStrokePath(context);
}


@end
