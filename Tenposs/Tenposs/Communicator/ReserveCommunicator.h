//
//  ReserveCommunicator.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/5/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossCommunicator.h"
#import "DataModel.h"

@interface ReserveResponse : JSONModel
@property(assign, nonatomic) NSInteger code;
@property(strong, nonatomic) NSString *message;
@property(strong, nonatomic) NSMutableArray <ConvertOnDemand, ReserveObject> *reserve;
@end

@interface ReserveCommunicator : TenpossCommunicator

@end
