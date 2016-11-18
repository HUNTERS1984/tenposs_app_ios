//
//  Item_Cell_Product_t2.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common_Item_Cell.h"

typedef void (^productSelectHandler)(ProductObject *p);
typedef void (^headerSelectHandler)(NSInteger headerScreenId);

@interface Item_Cell_Product_t2 : Common_Item_Cell <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) productSelectHandler productHandler;
@property (nonatomic, copy) headerSelectHandler headerHandler;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;

- (void)configureCellWithData:(NSObject *)data productSelectHandler:(productSelectHandler)productHandler andHeaderSelectHandler:(headerSelectHandler)headerHandler;

+ (CGSize)calculateSizeWithWidth:(CGFloat)fullWidth;

@end
