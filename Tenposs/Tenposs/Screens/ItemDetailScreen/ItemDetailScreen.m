//
//  ItemDetailScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/23/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "ItemDetailScreen.h"
#import "ItemDetailCommunicator.h"
#import "Item_Detail_ItemName.h"
#import "Item_Detail_TopImage.h"
#import "Item_Detail_Description.h"
#import "Item_Detail_Header_Segmented.h"
#import "Top_Header.h"
#import "Top_Footer.h"

@interface ItemDetailScreen ()

@property ItemDetailResponse *itemDetail;

@end

@implementation ItemDetailScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (BOOL)hasRelatedItems{
    return _itemDetail.items && [_itemDetail.items count] > 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:{
            if ([self hasRelatedItems]) {
                return [_itemDetail.items count];
            }else return 0;
        }
            break;
        default:
            return 0;
            break;
    }
}

//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self hasRelatedItems]?3:2;
}

@end
