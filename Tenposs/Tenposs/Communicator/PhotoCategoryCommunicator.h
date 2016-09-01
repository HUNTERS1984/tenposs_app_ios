//
//  PhotoCategoryCommunicator.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/31/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossCommunicator.h"
#import "DataModel.h"

@interface PhotoCategoryListModel : JSONModel
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSMutableArray<ConvertOnDemand,PhotoCategory> *items;
@end

@interface PhotoCategoryCommunicator : TenpossCommunicator

@end
