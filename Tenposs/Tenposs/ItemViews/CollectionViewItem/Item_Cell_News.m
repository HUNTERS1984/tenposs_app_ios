//
//  Item_Cell_News.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/27/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_News.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface Item_Cell_News()

@property (weak, nonatomic) IBOutlet UIImageView *newsImage;
@property (weak, nonatomic) IBOutlet UILabel *newsCategory;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsDescription;

@end

@implementation Item_Cell_News

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//-(void)configureCellWithData:(NewsObject *)data{
//    //TODO: need implementation
//
//}

- (void)configureCellWithData:(NSObject *)data{
    NewsObject *news = (NewsObject *)data;
    if (!news) {
       return;
    }
//    [_newsCategory setText:news.parentCategory.categoryName];
    [_newsTitle setText:news.title];
    [_newsDescription setText:news.desc];
    [_newsImage sd_setImageWithURL:[NSURL URLWithString:news.image_url]];
    _newsImage.layer.masksToBounds = YES;
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
