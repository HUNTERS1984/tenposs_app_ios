//
//  StaffCategoryCommunicator.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/11/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossCommunicator.h"
#import "DataModel.h"

@interface StaffCategoryResponse : JSONModel
@property (assign, nonatomic) NSInteger code;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSMutableArray<ConvertOnDemand,StaffCategory> *categories;
@end

@interface StaffCategoryCommunicator : TenpossCommunicator
@end
