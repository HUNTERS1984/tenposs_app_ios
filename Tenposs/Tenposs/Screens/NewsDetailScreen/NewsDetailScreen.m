//
//  NewsDetailScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/12/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "NewsDetailScreen.h"
#import "UIViewController+LoadingView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NewsDetailScreen ()

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UITextView *newsContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsContentHeightConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

@end

@implementation NewsDetailScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.newsTitle setText:_news.title];
    [self.categoryTitle setText:_news.parentCategory.name];
    [self.date setText:@"2016-08-14"];
    [self.newsContent setText:_news.desc];
    self.newsContent.textAlignment = NSTextAlignmentJustified;
    [self.newsContent setFont:[UIFont systemFontOfSize:16]];
    [self.thumbnail sd_setImageWithURL:[NSURL URLWithString:self.news.image_url]];
    self.thumbnail.clipsToBounds = YES;
    [self showLoadingViewWithMessage:@""];
    [self setTitle:_news.title];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGFloat contentBottom = self.newsContent.frame.origin.y;
    CGFloat allHeight = [self.newsContent sizeThatFits:CGSizeMake(self.newsContent.frame.size.width, CGFLOAT_MAX)].height;
    CGFloat neededHeight = allHeight ;
        self.newsContentHeightConstrain.constant = allHeight;
        self.contentViewHeightConstraint.constant = neededHeight + contentBottom;
    [self.view needsUpdateConstraints];
    [self removeLoadingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
