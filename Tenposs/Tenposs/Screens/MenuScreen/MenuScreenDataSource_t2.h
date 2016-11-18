//
//  MenuScreenDataSource_t2.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewPagerController.h"
#import <UIKit/UIKit.h>
#import "MenuCommunicator.h"
#import "Const.h"
#import "Utils.h"

typedef void (^MenuScreenLoadedHandler)(NSError *error);

@protocol PagerDataSourceDelegate <NSObject>

-(void)onTabLoaded;
-(void)onItemSelected;

@end

@interface MenuScreenDataSource_t2 : NSObject <ViewPagerDataSource, ViewPagerDelegate, TenpossCommunicatorDelegate>

@property(strong, nonatomic) UINavigationController *mainNavigationController;

- (void)fetchDataWithCompleteHandler:(MenuScreenLoadedHandler)handler;

@end
