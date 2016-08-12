//
//  TopScreen.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/3/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bundle.h"

@interface TopScreen : UICollectionViewController
@property UINavigationController *mainNavigationController;

- (void)performNavigateToMenuScreen:(Bundle *)extraData;
- (void)performNavigateToNewsScreen:(Bundle *)extraData;

@end
