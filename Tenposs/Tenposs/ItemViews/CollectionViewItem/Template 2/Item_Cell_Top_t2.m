//
//  Item_Cell_Top_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/3/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_Top_t2.h"
#import "Item_Cell_Top_t2_slide.h"
#import "UIButton+HandleBlock.h"

#define t2_top_buttons_height  55

@interface Item_Cell_Top_t2 ()

@property (strong, nonatomic) NSMutableArray *topArray;
@property (assign, nonatomic)NSInteger currentPageIndex;

@end

@implementation Item_Cell_Top_t2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(NSObject *)data{
    
    self.topArray = (NSMutableArray *)data;
    if (!self.topArray
        || ![self.topArray isKindOfClass:[NSMutableArray class]]
        || [self.topArray count] <= 0) {
        return;
    }
    //Build Top cell
    CGFloat contentSizeWidth = self.bounds.size.width;
    CGFloat contentSizeHeight = self.bounds.size.width/2;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(contentSizeWidth * [self.topArray count], contentSizeHeight);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages = [self.topArray count];
    self.pageControl.currentPage = 0;
    
    if (!self.currentPageIndex) {
        [self loadPageContent:0];
        [self loadPageContent:1];
    }else{
        [self loadPageContent:self.currentPageIndex];
        self.pageControl.currentPage = self.currentPageIndex;
    }
}

- (void)loadPageContent:(NSInteger)pageIndex{
    if (pageIndex >= [self.topArray count]) {
        return;
    }
    
    CGRect frame = _scrollView.bounds;
    frame.origin.x = CGRectGetWidth(frame) * pageIndex;
    frame.origin.y = 0;
    
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
//    imageView.backgroundColor = [UIColor lightGrayColor];
//    [imageView setContentMode:UIViewContentModeScaleAspectFill];
//    imageView.clipsToBounds = YES;
//    [imageView sd_setImageWithURL:[NSURL URLWithString:top.image_url]];
    
    NSObject *item = [_topArray objectAtIndex:pageIndex];
    Item_Cell_Top_t2_slide *couponView = nil;
    
    if([item isKindOfClass:[TopObject class]]){
        couponView = [[Item_Cell_Top_t2_slide alloc]
                      initWithFrame:frame
                      andCoupon:(CouponObject *)item];

    }else if ([item isKindOfClass:[CouponObject class]]){
        couponView = [[Item_Cell_Top_t2_slide alloc]
                      initWithFrame:frame
                      andTopItem:(TopObject *)item];
    }
    
    if (couponView) {
        [couponView.useButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            //TODO: proccedd user coupon
        }];
        [self.scrollView addSubview:couponView];
        couponView.frame = frame;
        [couponView setNeedsLayout];
//        [couponView setNeedsUpdateConstraints];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    self.currentPageIndex = page;
    if ([self.topArray count] > self.currentPageIndex + 1) {
        [self loadPageContent:self.currentPageIndex +1];
    }
}

+ (CGFloat)getCellHeightWithWidth:(CGFloat)width{
    return width/2 + t2_top_buttons_height;
}

@end
