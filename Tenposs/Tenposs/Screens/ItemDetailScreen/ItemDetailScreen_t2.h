//
//  ItemDetailScreen_t2.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/9/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface ItemDetailScreen_t2 : UICollectionViewController<UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) ProductObject *item;
- (instancetype)initWithItem:(ProductObject *)item;
@end
