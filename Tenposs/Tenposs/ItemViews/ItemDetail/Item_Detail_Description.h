//
//  Item_Detail_Description.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item_Detail_Common.h"

@interface DescriptionCellInfo : NSObject

@property (assign, nonatomic) BOOL isCollapsed;
@property (strong, nonatomic) NSString *fullText;
@property (strong, nonatomic) NSString *collapsedText;
@property (assign, nonatomic) CGFloat fullSizeHeight;
- (void)calculateFullTextHeightWithWidth:(CGFloat)width;

@end

@interface Item_Detail_Description : Item_Detail_Common
- (void)configureCellWithData:(NSObject *)data WithWidth:(CGFloat)width;
@end
