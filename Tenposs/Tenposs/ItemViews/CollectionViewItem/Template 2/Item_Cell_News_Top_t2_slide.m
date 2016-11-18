//
//  Item_Cell_News_Top_t2_slide.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/13/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_News_Top_t2_slide.h"
#import "UIImageView+WebCache.h"

@interface Item_Cell_News_Top_t2_slide ()

@property (weak, nonatomic)IBOutlet UIView *view;

@end


@implementation Item_Cell_News_Top_t2_slide

- (instancetype)initWithFrame:(CGRect)frame andNews:(NewsObject *)news{
    self = [super initWithFrame:frame];
    if(self) {
        _news = news;
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        if ([self.subviews count] == 0) {
            [self setup];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        if ([self.subviews count] == 0) {
            [self setup];
        }
    }
    return self;
}

- (void)setup{
    _view = [self loadViewFromNib];
    _view.frame = self.bounds;
    _view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:_view];
}

- (UIView *)loadViewFromNib{
    
    NSBundle *bundle = [NSBundle mainBundle];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:bundle];
    
    UIView *v = (UIView *)[[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    return v;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!_news) {
        return;
    }
    [_thumb sd_setImageWithURL:[NSURL URLWithString:_news.image_url]];
    [_title setText:_news.title];
    [_desc setText:_news.desc];
}

+(CGFloat)getViewHeightWithWidth:(CGFloat)width{
    CGFloat thumbHeight = width/2;
    CGFloat titleHeight = 22 * 2;
    CGFloat descHeight = 18;
    CGFloat dateHeight = 18;
    
    CGFloat height = thumbHeight + 8 + titleHeight + 8 + descHeight + 8 + dateHeight;
    
    return height;
}

@end
