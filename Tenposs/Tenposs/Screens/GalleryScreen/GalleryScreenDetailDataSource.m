//
//  GalleryScreenDetailDataSource.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/21/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "GalleryScreenDetailDataSource.h"
#import "Item_Cell_Photo.h"
#import "MockupData.h"

#define SPACING_PHOTO 8
#define SPACING_ITEM_PHOTO 8

@implementation GalleryScreenDetailDataSource

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate andPhotoCategory:(PhotoCategory *)photoCategory{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.mainData = photoCategory;
    }
    return self;
}

- (void)reloadDataSource{
    self.mainData.pageindex = 0;
    [self.mainData removeAllPhotos];
    [self loadData];
}

- (void)loadData{
    //TODO: Loading photo for category
    if(!self.mainData){
        return;
    }
//    if([self.mainData.photos count] == self.mainData.total_photos){
//        if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
//            NSError *error = [NSError errorWithDomain:GalleryScreenDetailError_fullyLoaded code:-9904 userInfo:nil];
//            [self.delegate dataLoaded:self withError:error];
//        }
//        return;
//    }
    ///TODO: real connection to server
    
    NSData *data = nil;
    
    if ([self.mainData.photos count] <= 0) {
        data = [MockupData fetchDataWithResourceName:@"photo"];
    }
    
    NSError *error;
    PhotoCategory *category = [[PhotoCategory alloc] initWithData:data error:&error];
    
    if (error == nil) {
        if (category && [category.photos count] > 0) {
            for (PhotoObject *item in category.photos) {
                [self.mainData addPhoto:item];
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
        [self.delegate dataLoaded:self withError:error];
    }
    
}

- (void)registerClassForCollectionView:(UICollectionView *)collection{
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Photo class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Photo class])];
}

- (NSInteger)numberOfItem{
    return [self.mainData.photos count];
}

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.mainData.photos objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.mainData.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoObject *photo = (PhotoObject *)[self itemAtIndexPath:indexPath];
    Item_Cell_Photo *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Photo class]) forIndexPath:indexPath];
    if(cell && photo){
        [cell configureCellWithData:photo];
    }
    return cell;
}

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth{
    CGFloat width = (superWidth - 4*SPACING_ITEM_PHOTO)/3;
    CGFloat height = [Item_Cell_Photo getCellHeightWithWidth:width];
    return CGSizeMake(width,height);
}

- (CGSize)sizeForHeaderAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}

- (CGSize)sizeForFooterAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}

@end
