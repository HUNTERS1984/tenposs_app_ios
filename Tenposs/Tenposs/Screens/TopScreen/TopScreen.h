//
//  TopScreen.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/3/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bundle.h"
#import "DataModel.h"

@interface TopScreen : UICollectionViewController
@property UINavigationController *mainNavigationController;

//- (void)performNavigateToMenuScreen:(Bundle *)extraData;
//- (void)performNavigateToNewsScreen:(Bundle *)extraData;
//- (void)performNavigateToCouponScreen:(Bundle *)extraData;

- (void)handleItemTouched:(NSObject *)item;
- (void)performNavigateToScreenWithId:(NSInteger)screenId;
@end
