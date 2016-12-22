//
//  Item_Cell_News.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/27/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_News.h"
#import "UIImageView+WebCache.h"

@interface Item_Cell_News()

@property (weak, nonatomic) IBOutlet UIView *newsImageBoundary;
@property (weak, nonatomic) IBOutlet UIImageView *newsImage;
@property (weak, nonatomic) IBOutlet UILabel *newsCategory;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UITextView *newsDescription;

@end

@implementation Item_Cell_News

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(NSObject *)data{
    NewsObject *news = (NewsObject *)data;
    if (!news) {
       return;
    }
//    [_newsCategory setText:news.parentCategory.categoryName];
    [_newsTitle setText:news.title];
    
    NSError *error = nil;
    NSAttributedString *attString = [[NSAttributedString alloc] initWithData:[news.desc dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)} documentAttributes:nil error:&error];
    if (error) {
        NSLog(@"Error: %@ %s %i", error.localizedDescription, __func__, __LINE__);
    } else {
        // Clear text view
        _newsDescription.text = @"";
        // Append the attributed string
        [_newsDescription.textStorage appendAttributedString:attString];
    }
    _newsDescription.textAlignment = NSTextAlignmentJustified;
    [_newsDescription setFont:[UIFont systemFontOfSize:13]];
    //[_newsDescription setScrollEnabled:NO];

    [_newsCategory setText:news.parentCategory.name];
    _newsImageBoundary.layer.masksToBounds = NO;
    _newsImageBoundary.layer.shadowColor = [UIColor blackColor].CGColor;
    _newsImageBoundary.layer.shadowOffset = CGSizeMake(1, 1);
    _newsImageBoundary.layer.shadowOpacity = 0.2;
    _newsImageBoundary.layer.shadowRadius = 0.7;
    
    [_newsImage sd_setImageWithURL:[NSURL URLWithString:news.image_url]];
    _newsImage.clipsToBounds = YES;
}

+(CellSpanType)getCellSpanType{
    return CellSpanTypeLarge;
}

+(CGFloat)getCellHeightWithWidth:(CGFloat)width{
    
    CGFloat sideEdgeSpacing = 8 * 2;
    CGFloat topBotSpacing = 8*2;
    CGFloat imageHeight = (width - sideEdgeSpacing) /3;
    
    return imageHeight + topBotSpacing;
}

@end
