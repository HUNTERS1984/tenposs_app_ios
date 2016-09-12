//
//  GlobalMapping.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/30/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Bundle.h"

#define VC_EXTRA_NAVIGATION @"navigation_controller"

@interface GlobalMapping : NSObject

+(UIViewController *)getViewControllerWithId:(NSInteger)viewControlerId withExtraData:(Bundle *)extra;

@end
