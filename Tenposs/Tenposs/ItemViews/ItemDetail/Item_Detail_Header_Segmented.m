//
//  Item_Detail_Header_Segmented.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Detail_Header_Segmented.h"

@interface Item_Detail_Header_Segmented()

@property (weak, nonatomic) IBOutlet UIView *segmentControlWrapper;

@end

@implementation Item_Detail_Header_Segmented

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(NSObject *)data{
    _segmentControlWrapper.layer.cornerRadius = 5;
}

+ (CGFloat)getCellHeightWithWidth:(CGFloat)width{
    //TODO: need implement
    return 10 + 50 + 20 + 1;
}

@end
