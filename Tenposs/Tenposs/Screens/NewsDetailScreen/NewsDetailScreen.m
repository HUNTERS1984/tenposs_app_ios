//
//  NewsDetailScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/12/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "NewsDetailScreen.h"
#import "UIViewController+LoadingView.h"
#import "UIImageView+WebCache.h"
#import "AppConfiguration.h"
#import "HexColors.h"

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
    AppSettings *settings = [[AppConfiguration sharedInstance] getAvailableAppSettings];
    [self.newsTitle setText:_news.title];
    [self.categoryTitle setText:_news.parentCategory.name];
    if (settings.template_id == 2)
        [self.categoryTitle setTextColor:[UIColor colorWithHexString:@"3CB963"]];
    [self.date setText:_news.date];
    NSError *error = nil;
    NSAttributedString *attString = [[NSAttributedString alloc] initWithData:[_news.desc dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)} documentAttributes:nil error:&error];
    if (error) {
        NSLog(@"Error: %@ %s %i", error.localizedDescription, __func__, __LINE__);
    } else {
        // Clear text view
        self.newsContent.text = @"";
        // Append the attributed string
        [self.newsContent.textStorage appendAttributedString:attString];
    }

    self.newsContent.textAlignment = NSTextAlignmentJustified;
    [self.newsContent setFont:[UIFont systemFontOfSize:14]];
    [self.thumbnail sd_setImageWithURL:[NSURL URLWithString:self.news.image_url]];
    self.thumbnail.clipsToBounds = YES;
    [self showLoadingViewWithMessage:@""];
    [self setTitle:_news.title];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationBar *nav = self.navigationController.navigationBar;
    if (nav) {
        AppConfiguration *appConfig = [AppConfiguration sharedInstance];
        AppSettings *settings = [appConfig getAvailableAppSettings];
        
        [nav setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor colorWithHexString:settings.title_color], NSForegroundColorAttributeName,nil]];
    }
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
