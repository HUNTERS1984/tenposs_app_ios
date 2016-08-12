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
    self.mainData.pageIndex = 0;
    [self.mainData removeAllNews];
    [self loadData];
}

- (void)changeDataSourceTo:(NewsCategoryObject *)newMainData{
    self.mainData = nil;
    self.mainData = newMainData;
    [self loadData];
}

- (void)loadData{
    if (!self.mainData) {
        self.mainData = [NewsCategoryObject new];
    }
    if([self.mainData.news count] == self.mainData.totalnew){
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
            NSError *error = [NSError errorWithDomain:NewsScreenDetailError_fullyLoaded code:-9904 userInfo:nil];
            [self.delegate dataLoaded:self withError:error];
        }
        return;
    }
    ///TODO: real connection to server
    
    NSData *data = nil;
    
    if ([self.mainData.news count] <= 0) {
        data = [MockupData fetchDataWithResourceName:@"news_items_1"];
    }else{
        data = [MockupData fetchDataWithResourceName:@"news_items_2"];
    }
    
    NSError *error;
    NewsCategoryObject *newsData = [[NewsCategoryObject alloc] initWithData:data error:&error];
    
    if (error == nil) {
        if (newsData && [newsData.news count] > 0) {
            NSString *titleFormat = @"%@-%@";
            for (NewsObject *item in newsData.news) {
                NSString *title = [NSString stringWithFormat:titleFormat,self.mainData.title,item.title];
                item.title = title;
                [self.mainData addNews:item];
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
        [self.delegate dataLoaded:self withError:error];
    }
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

@end
