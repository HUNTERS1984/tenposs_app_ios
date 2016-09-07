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
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) ProductObject *detail;
@property (strong, nonatomic) NSMutableArray<ConvertOnDemand,ProductObject> *items;

@end

@interface ItemDetailCommunicator : TenpossCommunicator

@end
