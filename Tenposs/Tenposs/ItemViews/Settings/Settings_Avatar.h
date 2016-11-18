//
//  Settings_Avatar.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/11/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings_Avatar : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
- (void) configureCellWithData:(NSObject *)data;
+ (CGFloat)height;
@end
