//
//  Item_Detail_TopImage.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/23/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Detail_TopImage.h"
#import "UIImageView+WebCache.h"
//#import <SDWebImage/UIImageView+WebCache.h>

@interface Item_Detail_TopImage()
@property (weak, nonatomic) IBOutlet UIImageView *itemThumbnail;
@end

@implementation Item_Detail_TopImage

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(NSObject *)data{
    if ([data isKindOfClass:[NSString class]]) {
        NSString *imageURL = (NSString *)data;
        [_itemThumbnail sd_setImageWithURL:[NSURL URLWithString:imageURL]];
    }else{
        return;
    }
}

+(CGFloat)getCellHeightWithWidth:(CGFloat)width{
    return width;
}

@end
