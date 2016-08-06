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
@property(copy) TopFooterTouchHandler touchHandler;

@end

@implementation Top_Footer

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureFooterWithTitle:(NSString *)title withTouchHandler:(TopFooterTouchHandler)handler{
    [self.footerButton setTitle:title forState:UIControlStateNormal];
    [self.footerButton setTitle:title forState:UIControlStateHighlighted];
    self.touchHandler = handler;
}

- (IBAction)footerTouched:(id)sender {
    if (self.touchHandler) {
        self.touchHandler();
    }
}

+(CGFloat)height{
    return 10+40+10;
}

@end
