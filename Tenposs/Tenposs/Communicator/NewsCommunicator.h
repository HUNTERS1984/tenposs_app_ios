//
//  NewsCommunicator.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/12/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossCommunicator.h"
#import "JSONModel.h"
#import "DataModel.h"

@interface NewsCategoryResponse : JSONModel
@property (assign, nonatomic) NSInteger code;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSMutableArray<ConvertOnDemand,NewsCategoryObject> *news_categories;
@end

@interface NewsCommunicator : TenpossCommunicator

@end
