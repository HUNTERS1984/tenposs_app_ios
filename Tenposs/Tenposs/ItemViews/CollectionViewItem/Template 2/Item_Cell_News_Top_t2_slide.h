//
//  Item_Cell_News_Top_t2_slide.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/13/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface Item_Cell_News_Top_t2_slide : UIView

@property (weak, nonatomic) IBOutlet UIImageView *thumb;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *date;

@property (strong, nonatomic) NewsObject *news;

- (instancetype)initWithFrame:(CGRect)frame andNews:(NewsObject *)news;

- (instancetype)initWithCoder:(NSCoder *)aDecoder;

- (instancetype)initWithFrame:(CGRect)frame;

+(CGFloat)getViewHeightWithWidth:(CGFloat)width;

@end
