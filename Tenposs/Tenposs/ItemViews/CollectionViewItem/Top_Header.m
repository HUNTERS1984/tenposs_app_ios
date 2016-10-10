//
//  Top_Header.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Top_Header.h"

@interface Top_Header()

@property (weak, nonatomic) IBOutlet UILabel *headerTitle;

@end

@implementation Top_Header

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)configureHeaderWithTitle:(NSString *)title{
    [self.headerTitle setText:title];
}

+(CGFloat)height{
    return 50;
}

@end
