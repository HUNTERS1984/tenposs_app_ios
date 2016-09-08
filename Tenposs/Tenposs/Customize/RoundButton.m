//
//  RoundButton.m
//  Tenposs
//
//  Created by Luong Hong Quan on 9/6/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "RoundButton.h"

@implementation RoundButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = 3;
        self.clipsToBounds = true;
    }
    
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.layer.cornerRadius = 3;
        self.clipsToBounds = true;
    }
    
    return self;
}


@end
