//
//  Item_Cell_News_Top_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/13/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_News_Top_t2.h"
#import "Item_Cell_News_Top_t2_slide.h"

#define t2_news_top_pager_height 30

@interface Item_Cell_News_Top_t2 ()

@property (strong, nonatomic) NSMutableArray *topArray;
@property (assign, nonatomic)NSInteger currentPageIndex;

@end

@implementation Item_Cell_News_Top_t2

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setNeedsLayout];
    [self setNeedsUpdateConstraints];
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)layoutSubviews{
    [super layoutSubviews];
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
    if (pageIndex > [self.topArray count]) {
        return;
    }
    
    CGRect frame = _scrollView.frame;
    frame.origin.x = CGRectGetWidth(frame) * pageIndex;
    frame.origin.y = 0;
    CGFloat fullWidth = CGRectGetWidth(frame);
    if (fullWidth < CGRectGetWidth([UIScreen mainScreen].bounds)) {
        fullWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    }
    CGFloat newsHeight = [Item_Cell_News_Top_t2_slide getViewHeightWithWidth:fullWidth];
    CGSize newsSize = CGSizeMake(fullWidth, newsHeight);
    frame.size = newsSize;
    
    NSObject *item = [_topArray objectAtIndex:pageIndex];
    Item_Cell_News_Top_t2_slide *newsView = nil;
    
    if([item isKindOfClass:[NewsObject class]]){
        newsView = [[Item_Cell_News_Top_t2_slide alloc]
                      initWithFrame:frame
                      andNews:(NewsObject *)item];
    }
    
    if (newsView) {
        [self.scrollView addSubview:newsView];
        newsView.frame = frame;
        [newsView setNeedsLayout];
        [self.scrollView setNeedsLayout];
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
    CGFloat newsHeight = [Item_Cell_News_Top_t2_slide getViewHeightWithWidth:width];
    return newsHeight + t2_news_top_pager_height;
}

@end
