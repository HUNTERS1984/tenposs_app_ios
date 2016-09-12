//
//  NewsScreenDetailDataSource.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/12/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "NewsScreenDetailDataSource.h"
#import "DataModel.h"
#import "MockupData.h"
#import "Item_Cell_News.h"
#import "Utils.h"
#import "AppConfiguration.h"

@implementation NewsScreenDetailDataSource

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate andNewsCategory:(NewsCategoryObject *)newsCategory{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.mainData = newsCategory;
    }
    return self;
}

-(void)reloadDataSource{
    self.mainData.pageIndex = 1;
    [self.mainData removeAllNews];
    [self loadData];
}

- (void)changeDataSourceTo:(NewsCategoryObject *)newMainData{
    self.mainData = nil;
    self.mainData = newMainData;
    [self loadData];
}

- (void)loadData{
    if([self.mainData.news count] != 0 && [self.mainData.news count] == self.mainData.totalnew){
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
            NSError *error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_CONTENT_FULLY_LOADED]  code:ERROR_CONTENT_FULLY_LOADED userInfo:nil];
            [self.delegate dataLoaded:self withError:error];
        }
        return;
    }
//    ///TODO: real connection to server
//    
//    NSData *data = nil;
//    
//    if ([self.mainData.news count] <= 0) {
//        data = [MockupData fetchDataWithResourceName:@"news_items_1"];
//    }else{
//        data = [MockupData fetchDataWithResourceName:@"news_items_2"];
//    }
//    
//    NSError *error;
//    NewsCategoryObject *newsData = [[NewsCategoryObject alloc] initWithData:data error:&error];
//    
//    if (error == nil) {
//        if (newsData && [newsData.news count] > 0) {
//            NSString *titleFormat = @"%@-%@";
//            for (NewsObject *item in newsData.news) {
//                NSString *title = [NSString stringWithFormat:titleFormat,self.mainData.title,item.title];
//                item.title = title;
//                [self.mainData addNews:item];
//            }
//        }
//    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
//        [self.delegate dataLoaded:self withError:error];
//    }
    
    NewsItemCommunicator *request = [NewsItemCommunicator new];
    Bundle *params = [Bundle new];
    [params put:KeyAPI_APP_ID value:APP_ID];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    [params put:KeyAPI_TIME value:currentTime];
    NSArray *strings = [NSArray arrayWithObjects:APP_ID,currentTime,[@(_mainData.store_id) stringValue],APP_SECRET,nil];
    [params put:KeyAPI_SIG value:[Utils getSigWithStrings:strings]];
    [params put:KeyAPI_STORE_ID value:[@(_mainData.store_id) stringValue]];
    [params put:KeyAPI_PAGE_INDEX value:[@(_mainData.pageIndex) stringValue]];
    [params put:KeyAPI_PAGE_SIZE value:@"20"];
    [request execute:params withDelegate:self];

}

- (void)registerClassForCollectionView: (UICollectionView *)collection{
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_News class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_News class])];
}

- (NSInteger)numberOfItem{
    return [self.mainData.news count];
}

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.mainData.news objectAtIndex:indexPath.row];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.mainData.news count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NewsObject *item = (NewsObject *)[self itemAtIndexPath:indexPath];
    Item_Cell_News *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_News class]) forIndexPath:indexPath];
    if (cell && item) {
        [cell configureCellWithData:item];
    }
    return cell;
}

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth{
    CGFloat width = superWidth;
    CGFloat height = [Item_Cell_News getCellHeightWithWidth:width];
    return CGSizeMake(width,height);
}

- (CGSize)sizeForHeaderAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}

- (CGSize)sizeForFooterAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}

#pragma mark - TenpossCommunicatorDelegate

- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
    NSError *error = nil;
    if (errorCode != ERROR_OK) {
        NSString *errorDomain = [responseParams get:KeyResponseError];
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
    }else{
        NewsItemResponse *data = (NewsItemResponse *)[responseParams get:KeyResponseObject];
        if (data.news && [data.news count] > 0) {
            _mainData.totalnew = data.total_news;
            for (NewsObject *news in data.news) {
                [_mainData addNews:news];
                [_mainData increasePageIndex:1];
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
        [self.delegate dataLoaded:self withError:error];
    }
}

- (void)begin:(TenpossCommunicator*)request data:(Bundle*) responseParams{}

-( void)cancelAllRequest{}

@end
