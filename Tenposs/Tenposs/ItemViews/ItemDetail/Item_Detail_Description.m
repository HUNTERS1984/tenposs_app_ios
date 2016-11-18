//
//  Item_Detail_Description.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Detail_Description.h"


@implementation DescriptionCellInfo

- (instancetype)initWithFullText:(NSString *)text{
    self = [super init];
    if (self) {
        _fullText = text;
        _isCollapsed = YES;
        _collapsedText = nil;
        _fullSizeHeight = -1;
    }
    return self;
}

- (NSString *)getCollapseText{
    if (_collapsedText) {
        return _collapsedText;
    }else{
        
    }
    return @"";
}

- (void)calculateFullTextHeightWithWidth:(CGFloat)width{
    if ( _fullSizeHeight > 0) {
        return;
    }
    if(!_fullText || [_fullText isEqualToString:@""]){
        _fullSizeHeight = 0;
    }else{
        @autoreleasepool {
            UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, MAXFLOAT)];
            [textView setText:_fullText];
            textView.scrollEnabled = NO;
            CGSize sizeThatFit = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)];
            _fullSizeHeight = sizeThatFit.height;
        }
    }
}

@end

@interface Item_Detail_Description()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation Item_Detail_Description

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(NSObject *)data WithWidth:(CGFloat)width{
    if (![data isKindOfClass:[DescriptionCellInfo class]]) {
        return;
    }else{
        DescriptionCellInfo *cellInfo = (DescriptionCellInfo *)data;
        self.textView.scrollEnabled = NO;
        self.textView.textContainer.maximumNumberOfLines = 0;
        self.textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.textView setText:cellInfo.fullText];
        self.textView.textAlignment = NSTextAlignmentJustified;
        if(cellInfo.isCollapsed){
            _heightConstraint.constant = DETAIL_DESCRIPTION_COLLAPSE;
        }else {
            if(cellInfo.fullSizeHeight <= 0){
                [cellInfo calculateFullTextHeightWithWidth:width];
            }
            if (cellInfo.fullSizeHeight > 0) {
                _heightConstraint.constant = cellInfo.fullSizeHeight;
            }
        }
        [self setNeedsLayout];
    }
}

@end
