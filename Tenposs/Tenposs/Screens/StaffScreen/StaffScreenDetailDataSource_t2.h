//
//  StaffScreenDetailDataSource_t2.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SimpleDataSource.h"
#import "DataModel.h"
#import "StaffCommunicator.h"

@interface StaffScreenDetailDataSource_t2 : SimpleDataSource

@property(strong, nonatomic) StaffCategory *mainData;

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate andStaffCategory:(StaffCategory *)category;
- (instancetype)initWithStaffCategory:(StaffCategory *)category;

@end
