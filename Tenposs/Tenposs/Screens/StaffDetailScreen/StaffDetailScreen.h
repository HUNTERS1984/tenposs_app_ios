//
//  StaffDetailScreen.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface StaffDetailScreen : UICollectionViewController

@property(strong, nonatomic)StaffObject *staff;
- (instancetype)initWithStaff:(StaffObject *)staff;
@end
