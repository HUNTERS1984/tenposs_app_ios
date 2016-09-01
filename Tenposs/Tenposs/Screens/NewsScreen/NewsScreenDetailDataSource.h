//
//  NewsScreenDetailDataSource.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/12/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SimpleDataSource.h"
#import "DataModel.h"

#define NewsScreenDetailError_fullyLoaded   @"Loaded all records"


@interface NewsScreenDetailDataSource : SimpleDataSource
@property(strong, nonatomic) NewsCategoryObject *mainData;
- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate andNewsCategory:(NewsCategoryObject *)newsCategory;
@end
