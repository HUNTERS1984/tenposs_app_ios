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
            textView.textAlignment = NSTextAlignmentCenter;
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
        self.textView.contentInset = UIEdgeInsetsMake(-4,0,0,0);
        NSError *error = nil;
        NSAttributedString *attString = [[NSAttributedString alloc] initWithData:[cellInfo.fullText dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)} documentAttributes:nil error:&error];
        if (error) {
            NSLog(@"Error: %@ %s %i", error.localizedDescription, __func__, __LINE__);
        } else {
            // Clear text view
            self.textView.text = @"";
            // Append the attributed string
            [self.textView.textStorage appendAttributedString:attString];
        }
        
        self.textView.textAlignment = NSTextAlignmentJustified;
        [self.textView setFont:[UIFont systemFontOfSize:14]];

        
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
