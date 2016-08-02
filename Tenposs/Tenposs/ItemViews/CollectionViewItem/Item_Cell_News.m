//
//  Item_Cell_News.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/27/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_News.h"

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

-(void)configureCellWithData:(NewsObject *)news{
    //TODO: need implementation
    [_newsCategory setText:news.parentCategory.categoryName];
    [_newsTitle setText:news.title];
    [_newsDescription setText:news.desc];
    
}

+(CellSpanType)getCellSpanType{
    return CellSpanTypeLarge;
}

@end
