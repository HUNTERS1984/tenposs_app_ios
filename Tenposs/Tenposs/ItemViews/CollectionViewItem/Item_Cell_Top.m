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
}

- (void)loadPageContent:(NSInteger)pageIndex{
    if (pageIndex > [self.topArray count]) {
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
