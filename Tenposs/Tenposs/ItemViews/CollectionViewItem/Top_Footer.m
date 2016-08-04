//
//  Top_Footer.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Top_Footer.h"

@interface Top_Footer()

@property (weak, nonatomic) IBOutlet UIButton *footerButton;

@end

@implementation Top_Footer

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(CGFloat)height{
    return 10+40+10;
}

@end
