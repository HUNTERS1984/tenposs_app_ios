//
//  Item_Cell_Photo.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/27/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_Photo.h"

@interface Item_Cell_Photo()

@property (weak, nonatomic) IBOutlet UIImageView *photo;

@end

@implementation Item_Cell_Photo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(NSObject *)data{
    //TODO: load image
}

+(CellSpanType)getCellSpanType{
    return CellSpanTypeSmall;
}

@end
