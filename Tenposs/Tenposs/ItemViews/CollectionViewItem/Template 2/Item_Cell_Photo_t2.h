//
//  Item_Cell_Photo_t2.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common_Item_Cell.h"
#import "Item_Cell_Product_t2.h"

typedef void (^photoSelectHandler)(PhotoObject *p);

@interface Item_Cell_Photo_t2 : Common_Item_Cell <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *photos;
@property (nonatomic, copy) photoSelectHandler photoHandler;
@property (nonatomic, copy) headerSelectHandler headerHandler;

- (void)configureCellWithData:(NSObject *)data photoSelectHandler:(photoSelectHandler)photoHandler andHeaderSelectHandler:(headerSelectHandler)headerHandler;

+ (CGSize)calculateSizeWithWidth:(CGFloat)fullWidth;

@end
