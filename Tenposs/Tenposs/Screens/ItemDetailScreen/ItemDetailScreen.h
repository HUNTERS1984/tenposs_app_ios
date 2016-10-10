//
//  ItemDetailScreen.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/23/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
@import SafariServices;

@interface ItemDetailScreen : UICollectionViewController <UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) ProductObject *item;
@end
