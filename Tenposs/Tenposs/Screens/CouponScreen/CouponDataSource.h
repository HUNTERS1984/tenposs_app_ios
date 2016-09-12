//
//  CouponDataSource.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/22/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SimpleDataSource.h"
#import "CouponCommunicator.h"


#define CouponDetailError_fullyLoaded    @"Loaded all records"

@interface CouponDataSource : SimpleDataSource<TenpossCommunicatorDelegate>

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate andStoreId:(NSInteger)store_id;

@end
