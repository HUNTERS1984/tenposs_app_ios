//
//  StaffDetailScreen_t2.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/9/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface StaffDetailScreen_t2 : UICollectionViewController<UICollectionViewDelegateFlowLayout>
@property(strong, nonatomic)StaffObject *staff;
- (instancetype)initWithStaff:(StaffObject *)staff;
@end
