//
//  NewsScreenDetailDataSource_t2.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/13/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SimpleDataSource.h"
#import "DataModel.h"
#import "NewsItemCommunicator.h"

@interface NewsScreenDetailDataSource_t2 : SimpleDataSource<TenpossCommunicatorDelegate>

@property(strong, nonatomic) NewsCategoryObject *mainData;

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate andNewsCategory:(NewsCategoryObject *)newsCategory;
- (instancetype)initWithNewsCategory:(NewsCategoryObject *)newsCategory;

@end
