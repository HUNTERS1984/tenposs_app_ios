//
//  APIService.h
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 12/16/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TenpossCommunicator.h"

typedef void (^APIServiceCompleteHandler)(BOOL isSusscess, id resultData, NSError *error);

@interface APIService : TenpossCommunicator

@end
