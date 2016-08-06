//
//  Top_Header.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Top_Header : UICollectionReusableView
- (void)configureHeaderWithTitle:(NSString *)title;
+(CGFloat)height;
@end
