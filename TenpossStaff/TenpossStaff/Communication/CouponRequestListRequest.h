//
//  CouponRequestListRequest.h
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/14/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import "TenpossCommunicator.h"
#import "DataModel.h"


@interface CouponRequestListResponse : JSONModel <CouponRequestContainer>

@property(assign, nonatomic) NSInteger code;
@property(strong, nonatomic) NSString *message;
@property(strong, nonatomic) NSMutableArray <ConvertOnDemand, CouponRequestModel> *list_request;
@property(assign, nonatomic) NSInteger total;

@end

@interface CouponRequestListRequest : TenpossCommunicator

@end
