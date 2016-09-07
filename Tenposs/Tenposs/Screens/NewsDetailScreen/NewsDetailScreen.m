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
    
    //[self showLoadingViewWithMessage:@""];
    
//    NSString *contentString = @"Lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit. In diam ante, tempus ullamcorper erat at, placerat dictum diam. Suspendisse potenti. Fusce interdum, augue non interdum pellentesque, velit velit interdum ex, at sagittis sem nulla at ipsum. Proin posuere ex vitae odio cursus placerat. Nunc felis turpis, fringilla ut ultricies sed, sodales non elit. Phasellus sit amet lacus quis felis commodo sagittis. In eu ornare elit, venenatis hendrerit lorem. Donec elementum mollis elementum. Integer tempus sem non pellentesque lacinia. Etiam dapibus dictum sapien non convallis.\n\nCras id tincidunt diam. Nunc nibh metus, ultricies eu gravida elementum, feugiat in justo. Sed sed vestibulum velit. Sed et sapien eget elit sodales porttitor. In sed nisi dignissim, ultricies enim non, auctor purus. Sed consequat tellus quam, id consequat turpis vestibulum eget. Curabitur gravida nisl id vestibulum ultrices. Nulla ut nisi fermentum, consectetur ex id, dapibus nunc. Etiam tristique molestie posuere.\n\n\nSed blandit ligula sit amet finibus finibus. Suspendisse ornare diam non elit luctus varius. Morbi in erat vehicula, semper dolor eu, pellentesque eros. Cras consectetur scelerisque blandit. Nunc sit amet lobortis ante. Donec urna velit, lacinia ut tristique eu, ullamcorper nec lacus. Donec aliquet rutrum leo sit amet ultrices. Mauris tincidunt semper felis ut accumsan. Interdum et malesuada fames ac ante ipsum primis in faucibus. Ut non elit eget dui vulputate molestie. Etiam lobortis lacinia feugiat. Nullam convallis nibh ante, a laoreet mauris tempus ut. Donec id sapien quis lectus facilisis ullamcorper. Nulla egestas sit amet ex vitae ultrices.\n\nClass aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Cras imperdiet nibh id nisl euismod, id scelerisque dui hendrerit. Suspendisse diam sem, elementum sit amet lorem quis, porta molestie velit. Quisque sollicitudin erat et lectus molestie volutpat. Curabitur pharetra nulla a velit placerat convallis. Aliquam neque libero, feugiat a malesuada et, commodo at eros. Cras augue magna, tristique ut sem eu, egestas elementum ipsum. Vivamus sodales rhoncus nibh sit amet hendrerit. Integer fringilla eleifend blandit. Cras mattis ligula eu eros sodales, et dapibus lectus fermentum.\n\nQuisque arcu eros, interdum sit amet ipsum a, efficitur condimentum libero. Aliquam sed consequat ipsum, et commodo nibh. Duis vulputate elit imperdiet, pharetra velit maximus, pellentesque justo. Interdum et malesuada fames ac ante ipsum primis in faucibus. Quisque placerat aliquet nisl, quis vestibulum quam tristique ac. Aenean maximus felis eu mauris eleifend egestas id sed eros. Vivamus a nisi venenatis, luctus sem quis, mattis tellus.";
//    
    [self.newsTitle setText:_news.title];
    [self.categoryTitle setText:@"August"];
    [self.date setText:@"2016-08-14"];
    [self.newsContent setText:_news.desc];
    [self.newsContent setFont:[UIFont systemFontOfSize:16]];
    [self.thumbnail sd_setImageWithURL:[NSURL URLWithString:self.news.image_url]];
    self.thumbnail.clipsToBounds = YES;
    [self showLoadingViewWithMessage:@""];
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
