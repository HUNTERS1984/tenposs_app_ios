//
//  Common_Table_Cell.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "UIImageView+WebCache.h"


@interface Common_Table_Cell : UITableViewCell

- (void)configureCellWithData:(NSObject *)data;

+ (CGFloat)getHeightWithWidth:(CGFloat)width;

@end
