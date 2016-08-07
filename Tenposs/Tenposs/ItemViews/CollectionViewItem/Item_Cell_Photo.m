//
//  Item_Cell_Photo.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/27/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_Photo.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DataModel.h"

@interface Item_Cell_Photo()

@property (weak, nonatomic) IBOutlet UIImageView *photo;

@end

@implementation Item_Cell_Photo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(NSObject *)data{
    PhotoObject *photo = (PhotoObject *)data;
    
    if (!photo || ![photo isKindOfClass:[PhotoObject class]]) {
        return;
    }
    //TODO: load image
    [self.photo sd_setImageWithURL:[NSURL URLWithString:photo.image_url]];
}

+(CellSpanType)getCellSpanType{
    return CellSpanTypeSmall;
}

+(CGFloat)getCellHeightWithWidth:(CGFloat)width{
    //All photo padding 8 at leading
    CGFloat height = width;
    return height;
}

@end
