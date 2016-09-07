//
//  NewsItemCommunicator.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossCommunicator.h"
#import "DataModel.h"

@interface NewsItemResponse : JSONModel
@property(assign, nonatomic) NSInteger code;
@property(strong, nonatomic) NSString *message;
@property(strong, nonatomic) NSMutableArray <ConvertOnDemand, NewsObject> *news;
@property(assign, nonatomic) NSInteger total_news;
@end

@interface NewsItemCommunicator : TenpossCommunicator

@end
