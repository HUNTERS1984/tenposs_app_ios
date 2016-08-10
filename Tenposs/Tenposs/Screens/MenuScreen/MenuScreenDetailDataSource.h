//
//  MenuScreenDetailDataSource.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/9/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleDataSource.h"
#import "MenuCommunicator.h"
#import "MockupData.h"

#define MenuScreenDetailError_fullyLoaded   @"Loaded all records"

@interface MenuScreenDetailDataSource : SimpleDataSource

@property (strong, nonatomic) MenuCategoryModel *mainData;
- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate andMenuCategory:(MenuCategoryModel *)menuCategory;
@end
