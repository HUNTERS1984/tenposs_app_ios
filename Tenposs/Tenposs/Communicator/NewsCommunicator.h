//
//  NewsCommunicator.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/12/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossCommunicator.h"
#import "JSONModel.h"

@protocol NewsCategoryObject
@end

@interface NewsCategoryListModel : JSONModel
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSMutableArray<ConvertOnDemand,NewsCategoryObject> *items;
@end

@interface NewsCommunicator : TenpossCommunicator

@end
