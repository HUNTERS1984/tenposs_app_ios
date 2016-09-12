//
//  StaffScreenDetailDataSource.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/11/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SimpleDataSource.h"
#import "DataModel.h"
#import "SimpleDataSource.h"

@interface StaffScreenDetailDataSource : SimpleDataSource
@property(strong, nonatomic) StaffCategory *mainData;

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate andStaffCategory:(StaffCategory *)category;

@end
