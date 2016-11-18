//
//  Settings_Avatar_t2.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/16/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings_Avatar_t2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
- (void) configureCellWithData:(NSObject *)data;
+ (CGFloat)height;

@end
