//
//  NewsScreenDetailDataSource_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/13/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "NewsScreenDetailDataSource_t2.h"
#import "Utils.h"
#import "AppConfiguration.h"
#import "Item_Cell_News_t2.h"
#import "Item_Cell_News_Top_t2.h"
#import "Item_Cell_News_Top_t2_slide.h"
#import "Top_Header_t2.h"
#import "UIButton+HandleBlock.h"

#define NEWS_TOP_COUNT 3

@interface NewsScreenDetailDataSource_t2()

@property(strong, nonatomic) NSMutableArray *collectionArray;

@end

@implementation NewsScreenDetailDataSource_t2

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate andNewsCategory:(NewsCategoryObject *)newsCategory{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.mainData = newsCategory;
    }
    return self;
}

- (instancetype)initWithNewsCategory:(NewsCategoryObject *)newsCategory{
    self = [super init];
    if (self) {
        self.mainData = newsCategory;
    }
    return self;
}

-(void)reloadDataSource{
    [self cancelOldRequest];
    self.mainData.pageIndex = 1;
    [self.mainData removeAllNews];
    self.mainData.totalnew = 0;
    [self loadData];
}

- (void)changeDataSourceTo:(NewsCategoryObject *)newMainData{
    self.mainData = nil;
    self.mainData = newMainData;
    [self loadData];
}

- (BOOL)isEqualTo:(SimpleDataSource *)second{
    if (![second isKindOfClass:[NewsScreenDetailDataSource_t2 class]]) {
        NSAssert(NO, @"DataSource type is not right!");
        return NO;
    }else{
        if (self.mainData.category_id == ((NewsScreenDetailDataSource_t2 *)second).mainData.category_id) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

- (void)loadData{
    if([self.mainData.news count] != 0 && [self.mainData.news count] == self.mainData.totalnew){
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
            NSError *error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_CONTENT_FULLY_LOADED]  code:ERROR_CONTENT_FULLY_LOADED userInfo:nil];
            [self.delegate dataLoaded:self withError:error];
        }
        return;
    }
    NewsItemCommunicator *request = [NewsItemCommunicator new];
    Bundle *params = [Bundle new];
    [params put:KeyAPI_APP_ID value:APP_ID];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    [params put:KeyAPI_TIME value:currentTime];
    NSArray *strings = [NSArray arrayWithObjects:APP_ID,currentTime,[@(_mainData.store_id) stringValue],APP_SECRET,nil];
    [params put:KeyAPI_SIG value:[Utils getSigWithStrings:strings]];
    [params put:KeyAPI_CATEGORY_ID value:[@(_mainData.category_id) stringValue]];
    //    [params put:KeyAPI_STORE_ID value:[@(_mainData.store_id) stringValue]];
    [params put:KeyAPI_PAGE_INDEX value:[@(_mainData.pageIndex) stringValue]];
    [params put:KeyAPI_PAGE_SIZE value:@"20"];
    [request execute:params withDelegate:self];
    
}

-(BOOL)sectionShouldHaveHeader:(NSInteger)section{
    switch (section) {
        case 0:
            return NO;
        case 1:
            return YES;
        default:
            return NO;
    }
    return NO;
}

- (void)buildCollectionArrayWithNews:(NSMutableArray *)newses{
    NSMutableArray *top = [NSMutableArray new];
    if (!_collectionArray) {
        _collectionArray = [NSMutableArray new];
    }else{
        [_collectionArray removeAllObjects];
    }
    
    if ([newses count] <= NEWS_TOP_COUNT) {
        if ([newses count] == 0) {
            [_collectionArray addObject:top];
            return;
        }
        for (NewsObject *news in newses) {
            [top addObject:news];
        }
        [_collectionArray addObject:top];
        return;
    }else{
        for (int i = 0; i < [newses count]; i ++) {
            if (i < NEWS_TOP_COUNT) {
                [top addObject:[newses objectAtIndex:i]];
            }else{
                [_collectionArray addObject:[newses objectAtIndex:i]];
            }
        }
        [_collectionArray insertObject:top atIndex:0];
    }
}

- (void)registerClassForCollectionView: (UICollectionView *)collection{
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_News_t2 class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_News_t2 class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_News_Top_t2 class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_News_Top_t2 class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Top_Header_t2 class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Top_Header_t2 class])];
}

- (NSInteger)numberOfItem{
    return [self.mainData.news count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger numberOfSection = 0;
    if ([_collectionArray count] > 1){
        numberOfSection = 2;
    }else if ([_collectionArray count] == 1) {
        numberOfSection = 1;
    }else{
        numberOfSection = 0;
    }
    return numberOfSection;
}

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *item = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    @try {
        switch (section) {
            case 0:{
                return [_collectionArray objectAtIndex:0];;
            }
                break;
            case 1:{
                return [_collectionArray objectAtIndex:row + 1];
            }
            default:
                break;
        }
    } @catch (NSException *exception) {
        NSLog(@"Error %@", exception.description);
    } @finally {
    }
    return item;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([_collectionArray count] > 1){
        if (section == 0) {
            return 1;
        }else{
            return [_collectionArray count] - 1;
        }
    }else if ([_collectionArray count] == 1) {
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *item = [self itemAtIndexPath:indexPath];
    Common_Item_Cell *cell = nil;
    if([item isKindOfClass:[NSMutableArray class]]){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_News_Top_t2 class]) forIndexPath:indexPath];
        [cell layoutIfNeeded];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_News_t2 class]) forIndexPath:indexPath];
    }
    
    if (cell) {
        [cell configureCellWithData:item];
    }
    
    return cell;
}

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth{
    NSInteger section = indexPath.section;
    CGFloat width = superWidth;
    CGFloat height = 0;
    
    switch (section) {
        case 0:{
            height = [Item_Cell_News_Top_t2 getCellHeightWithWidth:width];
        }
            break;
        case 1:{
            height = [Item_Cell_News_t2 getCellHeightWithWidth:width];
        }
            break;
        default:
            break;
    }
    return CGSizeMake(width,height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reuseableView = nil;
    NSInteger section = indexPath.section;
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (![self sectionShouldHaveHeader:section]) {
            return nil;
        }else{
            Top_Header_t2 *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([Top_Header_t2 class]) forIndexPath:indexPath];
            [((Top_Header_t2 *)header) configureHeaderWithMenuId:APP_MENU_NEWS];
            [((Top_Header_t2 *)header).headerButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                    //Do nothing at the meantime
            }];
            reuseableView = header;
        }
    }
    return reuseableView;
}

- (CGSize)sizeForHeaderAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    if (![self sectionShouldHaveHeader:section]) {
        return CGSizeZero;
    }else{
        return CGSizeMake(collectionView.bounds.size.width, 44);
    }
}

- (CGSize)sizeForFooterAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}

- (UIEdgeInsets)insetForSection:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 8, 0);
    }
    return UIEdgeInsetsMake(0, 0, 8, 0);
}

- (CGFloat)minimumInteritemSpacingForSection:(NSInteger)section{
    return 0;
}

- (CGFloat)minimumLineSpacingForSection:(NSInteger)section{
    return 0;
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
                news.parentCategory = _mainData;
                [_mainData addNews:news];
            }
            [self buildCollectionArrayWithNews:_mainData.news];
        }else {
            if ([_mainData.news count] > 0) {
                error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_CONTENT_FULLY_LOADED] code:ERROR_CONTENT_FULLY_LOADED userInfo:nil];
                
            }
            else{
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
