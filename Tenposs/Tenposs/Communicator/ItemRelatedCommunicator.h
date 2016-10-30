//
//  ItemRelatedCommunicator.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/27/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossCommunicator.h"
#import "DataModel.h"

@interface ItemRelatedResponse:JSONModel

@property (assign, nonatomic) NSInteger code;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSMutableArray<ConvertOnDemand,ProductObject> *items;
@property (assign, nonatomic) NSInteger total_items;

@end

@interface ItemRelatedCommunicator : TenpossCommunicator

@end
