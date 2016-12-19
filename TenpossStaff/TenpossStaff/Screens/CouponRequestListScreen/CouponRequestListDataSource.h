//
//  CouponRequestListDataSource.h
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/14/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import "SimpleDataSource.h"
#import "CouponRequestListRequest.h"

@interface CouponRequestListDataSource : SimpleDataSource

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate;

@end
