//
//  MenuScreenDataSource.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/9/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuCommunicator.h"
#import "MenuScreenDetailDataSource.h"
#import <UIKit/UIKit.h>
#import "MockupData.h"
#import "MenuCommunicator.h"
#import "TabDataSource.h"

@interface MenuScreenDataSource : TabDataSource <TenpossCommunicatorDelegate>

@end
