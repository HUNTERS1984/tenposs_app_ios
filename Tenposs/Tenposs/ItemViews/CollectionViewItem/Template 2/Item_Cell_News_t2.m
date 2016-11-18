//
//  Item_Cell_News_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_News_t2.h"

@implementation Item_Cell_News_t2

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setNeedsLayout];
    _thumb.clipsToBounds = YES;
}

- (void)configureCellWithData:(NSObject *)data{
    if (![data isKindOfClass:[NewsObject class]]) {
        return;
    }
    NewsObject *news = (NewsObject *)data;
    
    [_thumb sd_setImageWithURL:[NSURL URLWithString:news.image_url ]];
    [_title setText:news.title];
    [_desc setText:news.desc];
    [_date setText:@"this needs implemetation!"];
}

+(CGFloat)getCellHeightWithWidth:(CGFloat)width{
    CGFloat sideEdgeSpacing = 8 * 2;
    CGFloat topBotSpacing = 8*2;
    CGFloat imageHeight = (width - sideEdgeSpacing) /3;
    
    return imageHeight + topBotSpacing;
}

@end
