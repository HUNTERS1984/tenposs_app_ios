//
//  TopCommunicator.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/6/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossCommunicator.h"
#import "JSONModel.h"
#import "DataModel.h"

@interface TopDataModel : JSONModel
@property NSString *code;
@property NSString *message;
@property NSArray <ConvertOnDemand,ProductObject> *items;
@property NSArray <PhotoObject,ConvertOnDemand> *photos;
@property NSArray <NewsObject,ConvertOnDemand> *news;
@property NSArray <TopObject,ConvertOnDemand> *images;

@end

@interface TopCommunicator : TenpossCommunicator

@end
