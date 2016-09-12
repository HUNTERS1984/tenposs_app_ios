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
    NSString *imageURL = nil;
    if (data && [data isKindOfClass:[PhotoObject class]]) {
        PhotoObject *photo = (PhotoObject *)data;
        imageURL = photo.image_url;
    }else if (data && [data isKindOfClass:[NSString class]]){
        imageURL = (NSString *)data;
    }
    //TODO: load image
    [self.photo sd_setImageWithURL:[NSURL URLWithString:imageURL]];
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
