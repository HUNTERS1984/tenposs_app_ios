//
//  Top_Header_t2.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Top_Header_t2 : UICollectionReusableView

@property(weak, nonatomic)IBOutlet UIImageView *icon;
@property(weak, nonatomic)IBOutlet UILabel *title;
@property(weak, nonatomic)IBOutlet UIButton *headerButton;

- (void)configureHeaderWithMenuId:(NSInteger)menuId;
@end
