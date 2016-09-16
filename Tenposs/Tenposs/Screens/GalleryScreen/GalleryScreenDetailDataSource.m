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
#import "Utils.h"
#import "Const.h"

#define SPACING_PHOTO 8
#define SPACING_ITEM_PHOTO 8

@implementation GalleryScreenDetailDataSource

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate andPhotoCategory:(PhotoCategory *)photoCategory{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.mainData = photoCategory;
    }
    return self;
}

- (void)reloadDataSource{
    [self cancelOldRequest];
    _mainData.pageindex = 1;
    [_mainData removeAllPhotos];
    _mainData.total_photos = 0;
    [self loadData];
}

- (void)loadData{

    if([_mainData.photos count] > 0 && [_mainData.photos count] == _mainData.total_photos){
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
            NSError *error = [NSError errorWithDomain:@"" code:ERROR_CONTENT_FULLY_LOADED userInfo:nil];
            [self.delegate dataLoaded:self withError:error];
        }
        return;
    }
    
    PhotoCommunicator *request = [PhotoCommunicator new];
    Bundle *params = [Bundle new];
    [params put:KeyAPI_APP_ID value:APP_ID];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    [params put:KeyAPI_TIME value:currentTime];
    NSArray *strings = [NSArray arrayWithObjects:APP_ID,currentTime,[@(_mainData.category_id) stringValue],APP_SECRET,nil];
    [params put:KeyAPI_SIG value:[Utils getSigWithStrings:strings]];
    [params put:KeyAPI_CATEGORY_ID value:[@(_mainData.category_id) stringValue]];
    [params put:KeyAPI_PAGE_INDEX value:[@(_mainData.pageindex) stringValue]];
    [params put:KeyAPI_PAGE_SIZE value:@"20"];
    [request execute:params withDelegate:self];

}

- (BOOL)isEqualTo:(SimpleDataSource *)second{
    if (![second isKindOfClass:[GalleryScreenDetailDataSource class]]) {
        NSAssert(NO, @"DataSource type is not right!");
        return NO;
    }else{
        if (self.mainData.category_id == ((GalleryScreenDetailDataSource *)second).mainData.category_id) {
            return YES;
        }else{
            return NO;
        }
    }
}

- (void)registerClassForCollectionView:(UICollectionView *)collection{
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Photo class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Photo class])];
}

- (NSInteger)numberOfItem{
    return [_mainData.photos count];
}

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *item = nil;
    @try {
        item = [self.mainData.photos objectAtIndex:indexPath.row];
    } @catch (NSException *exception) {
        NSLog(@"Error %@", exception.description);
    } @finally {
        
    }
    return item;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_mainData.photos count];
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

- (UIEdgeInsets)insetForSection{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

#pragma mark - TenpossCommunicatorDelegate

- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
    NSError *error = nil;
    if (errorCode != ERROR_OK) {
        NSString *errorDomain = [CommunicatorConst getErrorMessage:errorCode];
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
    }else{
        PhotoResponse *data = (PhotoResponse *)[responseParams get:KeyResponseObject];
        if (data.photos && [data.photos count] > 0) {
            _mainData.total_photos = data.total_photos;
            for (PhotoObject *item in data.photos) {
                [_mainData addPhoto:item];
            }
        }else{
            if ([_mainData.photos count] > 0) {
                error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_CONTENT_FULLY_LOADED] code:ERROR_CONTENT_FULLY_LOADED userInfo:nil];
                
            }else{
                error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_DETAIL_DATASOURCE_NO_CONTENT] code:ERROR_DETAIL_DATASOURCE_NO_CONTENT userInfo:nil];
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
        [self.delegate dataLoaded:self withError:error];
    }
    [_mainData increasePageIndex:1];
}

- (void)begin:(TenpossCommunicator*)request data:(Bundle*) responseParams{}

-( void)cancelAllRequest{}

@end
