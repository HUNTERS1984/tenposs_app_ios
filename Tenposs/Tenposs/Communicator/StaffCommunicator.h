//
//  StaffCommunicator.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/11/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossCommunicator.h"
#import "DataModel.h"

@interface StaffResponse : JSONModel
@property(assign, nonatomic) NSInteger code;
@property(strong, nonatomic) NSString *message;
@property(strong, nonatomic) NSMutableArray <ConvertOnDemand, StaffObject> *staffs;
@property(assign, nonatomic) NSInteger total_staffs;
@end

@interface StaffCommunicator : TenpossCommunicator

@end
