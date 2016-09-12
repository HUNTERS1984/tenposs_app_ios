//
//  MenuDetailCommunicator.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/10/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossCommunicator.h"
#import "MenuCommunicator.h"

@interface MenuItemResponse : JSONModel
@property(assign, nonatomic) NSInteger code;
@property(strong, nonatomic) NSString *message;
@property(strong, nonatomic) NSMutableArray <ConvertOnDemand, ProductObject> *items;
@property(assign, nonatomic) NSInteger total_items;
@end

@interface MenuItemCommunicator : TenpossCommunicator

@end
