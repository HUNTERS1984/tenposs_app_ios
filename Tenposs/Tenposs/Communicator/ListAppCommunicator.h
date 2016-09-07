//
//  ListAppCommunicator.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/6/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossCommunicator.h"
#import "JSONModel.h"

@protocol ListAppModel
@end

@interface ListAppResponse: JSONModel

@property (assign, nonatomic) NSInteger code;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSMutableArray <ConvertOnDemand, ListAppModel> *data;

@end

@interface ListAppModel : JSONModel
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *app_app_id;
@property (strong, nonatomic) NSString *app_app_secret;
@end

@interface ListAppCommunicator : TenpossCommunicator

@end
