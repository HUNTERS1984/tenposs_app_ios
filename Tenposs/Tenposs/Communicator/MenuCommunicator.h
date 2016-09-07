//
//  MenuCommunicator.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TenpossCommunicator.h"
#import "JSONModel.h"
#import "DataModel.h"

@protocol MenuCategoryModel
@end

@interface MenuResponse : JSONModel
@property (assign, nonatomic) NSInteger code;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSMutableArray<ConvertOnDemand,MenuCategoryModel> *items;
@end

@interface MenuCategoryModel : JSONModel <ProductContainer>
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger menu_id;
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) NSInteger totalitem;
@property (strong, nonatomic) NSMutableArray<ConvertOnDemand,ProductObject> *items;
@end

@interface MenuCommunicator : TenpossCommunicator


@end
