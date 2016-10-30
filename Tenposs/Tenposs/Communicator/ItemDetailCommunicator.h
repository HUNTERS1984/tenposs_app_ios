//
//  ItemDetailCommunicator.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossCommunicator.h"
#import "DataModel.h"

@interface ItemDetailResponse:JSONModel
@property (assign, nonatomic) NSInteger code;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) ProductObject *detail;
@property (strong, nonatomic) NSMutableArray<ConvertOnDemand,ProductObject> *items_related;
@property (assign, nonatomic) NSInteger total_items_related;

@end

@interface ItemDetailCommunicator : TenpossCommunicator

@end
