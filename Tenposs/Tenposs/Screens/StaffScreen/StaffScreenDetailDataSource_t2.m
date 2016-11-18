//
//  StaffScreenDetailDataSource_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "StaffScreenDetailDataSource_t2.h"
#import "Const.h"
#import "Utils.h"
#import "Item_Cell_Staff_t2.h"

#define SPACING_STAFF 8
#define SPACING_ITEM_STAFF 8

@implementation StaffScreenDetailDataSource_t2

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate andStaffCategory:(StaffCategory *)category{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.mainData = category;
    }
    return self;
}

- (instancetype)initWithStaffCategory:(StaffCategory *)category{
    self = [super init];
    if (self) {
        self.mainData = category;
    }
    return self;
}

- (void)reloadDataSource{
    [self cancelOldRequest];
    self.mainData.pageindex = 1;
    [self.mainData removeAllStaff];
    [self loadData];
}

- (void)loadData{
    if([self.mainData.staffs count] > 0 && [self.mainData.staffs count] == self.mainData.total_staffs){
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
            NSError *error = [NSError errorWithDomain:@"" code:ERROR_CONTENT_FULLY_LOADED userInfo:nil];
            [self.delegate dataLoaded:self withError:error];
        }
        return;
    }
    
    StaffCommunicator *request = [StaffCommunicator new];
    Bundle *params = [Bundle new];
    [params put:KeyAPI_APP_ID value:APP_ID];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    [params put:KeyAPI_TIME value:currentTime];
    NSArray *strings = [NSArray arrayWithObjects:APP_ID,currentTime,[@(_mainData.staff_cate_id) stringValue],APP_SECRET,nil];
    [params put:KeyAPI_SIG value:[Utils getSigWithStrings:strings]];
    [params put:KeyAPI_CATEGORY_ID value:[@(_mainData.staff_cate_id) stringValue]];
    [params put:KeyAPI_PAGE_INDEX value:[@(_mainData.pageindex) stringValue]];
    [params put:KeyAPI_PAGE_SIZE value:@"20"];
    [request execute:params withDelegate:self];
    
}

- (BOOL)isEqualTo:(SimpleDataSource *)second{
    if (![second isKindOfClass:[StaffScreenDetailDataSource_t2 class]]) {
        NSAssert(NO, @"DataSource type is not right!");
        return NO;
    }else{
        if (self.mainData.staff_cate_id == ((StaffScreenDetailDataSource_t2 *)second).mainData.staff_cate_id) {
            return YES;
        }else{
            return NO;
        }
    }
}

- (void)registerClassForCollectionView:(UICollectionView *)collection{
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Staff_t2 class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Staff_t2 class])];
}

- (NSInteger)numberOfItem{
    return [self.mainData.staffs count];
}

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *item = nil;
    @try {
        item = [self.mainData.staffs objectAtIndex:indexPath.row];
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
    return [self.mainData.staffs count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    StaffObject *staff = (StaffObject *)[self itemAtIndexPath:indexPath];
    Item_Cell_Staff_t2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Staff_t2 class]) forIndexPath:indexPath];
    if(cell){
        [cell configureCellWithData:staff];
    }
    return cell;
}

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth{
    CGFloat width = (superWidth - 3*SPACING_ITEM_STAFF)/2;
    CGFloat height = [Item_Cell_Staff_t2 getCellHeightWithWidth:width];
    return CGSizeMake(width,height);
}

- (CGSize)sizeForHeaderAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}

- (CGSize)sizeForFooterAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}

- (UIEdgeInsets)insetForSection:(NSInteger)section{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

- (CGFloat)minimumLineSpacingForSection:(NSInteger)section{
    return 8;
}

- (CGFloat)minimumInteritemSpacingForSection:(NSInteger)section{
    return 8;
}

#pragma mark - TenpossCommunicatorDelegate

- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
    NSError *error = nil;
    if (errorCode != ERROR_OK) {
        NSString *errorDomain = [CommunicatorConst getErrorMessage:errorCode];
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
    }else{
        StaffResponse *data = (StaffResponse *)[responseParams get:KeyResponseObject];
        if (data.staffs && [data.staffs count] > 0) {
            _mainData.total_staffs = data.total_staffs;
            for (StaffObject *staff in data.staffs) {
                [_mainData addStaff:staff];
            }
        }else{
            if ([_mainData.staffs count] > 0) {
                error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_CONTENT_FULLY_LOADED] code:ERROR_CONTENT_FULLY_LOADED userInfo:nil];
                
            }else{
                error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_DETAIL_DATASOURCE_NO_CONTENT] code:ERROR_DETAIL_DATASOURCE_NO_CONTENT userInfo:nil];
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
        [self.delegate dataLoaded:self withError:error];
    }
    [_mainData increaseIndex:1];
}

- (void)begin:(TenpossCommunicator*)request data:(Bundle*) responseParams{}

-( void)cancelAllRequest{}
@end
