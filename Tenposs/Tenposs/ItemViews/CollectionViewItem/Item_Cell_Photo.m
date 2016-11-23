//
//  Item_Cell_Photo.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/27/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_Photo.h"
#import "UIImageView+WebCache.h"
#import "DataModel.h"
#import "AppConfiguration.h"

@interface Item_Cell_Photo()

@property (weak, nonatomic) IBOutlet UIImageView *photo;

@end

@implementation Item_Cell_Photo

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setNeedsLayout];
    self.photo.clipsToBounds = YES;
    AppSettings *settings = [[AppConfiguration sharedInstance] getAvailableAppSettings];
    if (settings.template_id == 1) {
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 1;
    }
}

- (void)configureCellWithData:(NSObject *)data{
    NSString *imageURL = nil;
    if (data && [data isKindOfClass:[PhotoObject class]]) {
        PhotoObject *photo = (PhotoObject *)data;
        imageURL = photo.image_url;
    }else if (data && [data isKindOfClass:[NSString class]]){
        imageURL = (NSString *)data;
    }

    [self.photo sd_setImageWithURL:[NSURL URLWithString:imageURL]];
}

+(CGFloat)getCellHeightWithWidth:(CGFloat)width{
    //All photo padding 8 at leading
    CGFloat height = width;
    return height;
}

@end
