//
//  Item_Cell_Top.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_Top.h"
#import "UIImageView+WebCache.h"

#define Top_ThumbnailRatio  2

@interface Item_Cell_Top()
@property (strong, nonatomic) NSMutableArray <TopObject *> *topArray;
@property (assign, nonatomic)NSInteger currentPageIndex;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation Item_Cell_Top

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(NSObject *)data{
    
    self.topArray = (NSMutableArray <TopObject *> *)data;
    if (!self.topArray
        || ![self.topArray isKindOfClass:[NSMutableArray<TopObject *> class]]
        || [self.topArray count] <= 0) {
        return;
    }
    //Build Top cell
    CGFloat cellScreenWidth = self.bounds.size.width;
    CGFloat cellScreenHeight = self.bounds.size.height;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(cellScreenWidth * [self.topArray count], cellScreenHeight);
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
    __weak Item_Cell_Top *weakSelf = self;
//    [NSTimer scheduledTimerWithTimeInterval:3.0 target:weakSelf selector:@selector(onTimer) userInfo:nil repeats:YES];
    if ([_topArray count] > 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf timerFire:nil];
        });
    }
}

- (void)setUpTimer {
    [self tearDownTimer];
    
    self.timer = [NSTimer timerWithTimeInterval:3.0
                                         target:self
                                       selector:@selector(timerFire:)
                                       userInfo:nil
                                        repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)tearDownTimer {
    [self.timer invalidate];
}

- (void)timerFire:(NSTimer *)timer {
    [self tearDownTimer];
    
    CGFloat x = 0;
    NSInteger nextIndex = _currentPageIndex + 1;
    if (nextIndex == [self.topArray count]) {
        //This is last page
        _currentPageIndex = 0;
        x = 0;
    }else if (nextIndex < [self.topArray count]) {
        CGRect frame = self.bounds;
        x = (_currentPageIndex + 1) * CGRectGetWidth(frame);
        _currentPageIndex = _currentPageIndex + 1;
    }else{
        x = 0;
        _currentPageIndex = 0;
    }
    
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    self.pageControl.currentPage = _currentPageIndex;
    
    [self setUpTimer];
}


- (void) onTimer {
    CGFloat x = 0;
    NSInteger nextIndex = _currentPageIndex + 1;
    if (nextIndex == [self.topArray count]) {
        _currentPageIndex = 0;
        x = 0;
    }else if (nextIndex < [self.topArray count]) {
        CGRect frame = self.bounds;
        x = (_currentPageIndex + 1) * CGRectGetWidth(frame);
        _currentPageIndex = _currentPageIndex + 1;
    }else{
        x = 0;
        _currentPageIndex = 0;
    }
    
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    self.pageControl.currentPage = _currentPageIndex;
}

- (void)loadPageContent:(NSInteger)pageIndex{
    if (pageIndex >= [self.topArray count]) {
        return;
    }
    
    TopObject *top = [self.topArray objectAtIndex:pageIndex];
    
    CGRect frame = self.bounds;
    frame.origin.x = CGRectGetWidth(frame) * pageIndex;
    frame.origin.y = 0;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.backgroundColor = [UIColor lightGrayColor];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    imageView.clipsToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:top.image_url]];
    
    [self.scrollView addSubview:imageView];
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

//+ (CellSpanType)getCellSpanType{
//    return CellSpanTypeLarge;
//}

+ (CGFloat)getCellHeightWithWidth:(CGFloat)width{
    return width / Top_ThumbnailRatio;
}

@end
