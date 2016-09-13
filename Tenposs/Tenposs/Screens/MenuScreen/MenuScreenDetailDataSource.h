//
//  MenuScreenDetailDataSource.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/9/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleDataSource.h"
#import "MockupData.h"
#import "MenuItemCommunicator.h"

@interface MenuScreenDetailDataSource : SimpleDataSource <TenpossCommunicatorDelegate>

@property (strong, nonatomic) MenuCategoryModel *mainData;
- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate andMenuCategory:(MenuCategoryModel *)menuCategory;
@end
