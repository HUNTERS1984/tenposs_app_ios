//
//  DataModel.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/2/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "DataModel.h"

@implementation TopObject
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end

#pragma mark - Product
@implementation ProductObject

- (instancetype)init{
    self = [super init];
    
    if (self) {
        _numberOfSizeColumn = -1;
        _rel_pageindex = 1;
        _rel_items = (NSMutableArray <ProductObject> *)[NSMutableArray new];
    }
    return self;
}

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
//TODO: need implementation

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"product_id"
                                                       ,@"description":@"desc"}];
}

- (void)updateItemWithItem:(ProductObject *)item{
    if (self.product_id != item.product_id) {
        return;
    }
    self.title = item.title;
    self.desc = item.desc;
    self.price = item.price;
    self.image_url = item.image_url;
}

- (NSMutableArray *)getSizeArray{
    if (!_size || [_size count] <= 0) {
        return nil;
    }
    if (_sizeArray && [_sizeArray count] > 0) {
        return _sizeArray;
    }else{
        _sizeArray = [NSMutableArray new];
        NSMutableArray *sizeObjectArray = [NSMutableArray new];
        NSMutableArray *sizeTypeArray = [NSMutableArray new];
        NSMutableArray *sizeCategoryArray = [NSMutableArray new];
        for (ProductSizeObject *size in _size) {
            if (size.item_size_type_name && ![sizeTypeArray containsObject:size.item_size_type_name]) {
                [sizeTypeArray addObject:size.item_size_type_name];
            }
            if(size.item_size_category_name && ![sizeCategoryArray containsObject:size.item_size_category_name]){
                [sizeCategoryArray addObject:size.item_size_category_name];
            }
        }
        
        _numberOfSizeColumn = [sizeTypeArray count] + 1;
        
        for (NSString *cateName in sizeCategoryArray) {
            [sizeObjectArray addObject:cateName];
            for (ProductSizeObject *size in _size) {
                NSMutableArray *s = [NSMutableArray new];
                if ([size.item_size_category_name isEqualToString:cateName] && ![s containsObject:size]) {
                    [s addObject:size];
                }
                NSSortDescriptor *sortDescriptor;
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"item_size_type_id"
                                                             ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                NSArray *sortedArray = [s sortedArrayUsingDescriptors:sortDescriptors];
                [sizeObjectArray addObjectsFromArray:sortedArray];
            }
        }
        
        if ([sizeTypeArray count] > 0 && [sizeObjectArray count] > 0) {
            [_sizeArray addObject:@" "];
            [_sizeArray addObjectsFromArray:sizeTypeArray];
            [_sizeArray addObjectsFromArray:sizeObjectArray];
            return _sizeArray;
        }
    }
    return nil;
}

-(NSInteger)getNumberOfSizeColumn{
    if (_numberOfSizeColumn == -1) {
        [self getSizeArray];
    }
    return _numberOfSizeColumn;
}

- (void)addRelatedItem:(ProductObject *)rel{
    if (![_rel_items containsObject:rel]) {
        [_rel_items addObject:rel];
    }
}

@end

@implementation ProductCategoryObject

- (instancetype)init{
    self = [super init];
    if (self) {
        self->products = (NSMutableArray<ProductObject *> *)[[NSMutableArray alloc]init];
    }
    return self;
}
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

//TODO: need implementation

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{}];
}
@end

@implementation ProductSizeObject


+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

//TODO: need implementation

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{}];
}

@end

#pragma mark - Gallery
@implementation PhotoObject
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

//TODO: need implementation

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"photo_id",@"photo_category_id":@"category_id",@"categoryname":@"category_name"}];
}
@end

@implementation PhotoCategory

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.photos = (NSMutableArray<PhotoObject> *)[[NSMutableArray alloc]init];
        _pageindex = 1;
    }
    return self;
}
//TODO: need implementation

+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"category_id"
                                                       }];
}

- (void)addPhoto:(PhotoObject *)photo{
    [self.photos addObject:photo];
}

- (void)increasePageIndex:(NSInteger)count{
    self.pageindex += count;
}

- (void)removeAllPhotos{
    [self.photos removeAllObjects];
    self.pageindex = 1;
}

@end

@implementation AllPhotoCategory

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.photo_categories = (NSMutableArray<PhotoCategory> *)[[NSMutableArray alloc]init];
    }
    return self;
}
//TODO: need implementation

+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data.photo_categories":@"photo_categories"}];
}

@end

#pragma mark - News
@implementation NewsObject
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
//TODO: need implementation

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"news_id",@"description":@"desc",@"title":@"title"}];
}
@end

@implementation NewsCategoryObject

- (instancetype)init{
    self = [super init];
    if (self) {
        self.news = (NSMutableArray<NewsObject> *)[[NSMutableArray alloc]init];
        self.pageIndex = 1;
    }
    return self;
}
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
//TODO: need implementation

+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data.news":@"news", @"id":@"category_id"}];
}

- (NSString *)title{
    return _name;
}

- (void)addNews:(NewsObject *)new{
    [self.news addObject:new];
}

- (void)increasePageIndex:(NSInteger)count{
    self.pageIndex += 1;
}

- (void)removeAllNews{
    [self.news removeAllObjects];
}

@end

#pragma mark - Store
@implementation ContactObject
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

//TODO: need implementation

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{}];
}

- (NSString *)getStartTimeString{
    if (_start_time_string) {
        return _start_time_string;
    }else{
        _start_time_string = [self convertDataToString:_start_time];
        if (!_start_time_string) {
            _start_time_string = @"00:00";
        }
        return _start_time_string;
    }
}

- (NSString *)getEndTimeString{
    if (_end_time_string) {
        return _end_time_string;
    }else{
        _end_time_string = [self convertDataToString:_end_time];
        if (!_end_time_string) {
            _end_time_string = @"00:00";
        }
        return _end_time_string;
    }
}

- (NSString *)convertDataToString:(NSString *)dateString{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateString];
    if (date) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
        NSInteger hour = [components hour];
        NSInteger minute = [components minute];
        return [NSString stringWithFormat:@"%ld:%ld", (long)hour, (long)minute];
    }
    return nil;
}

@end


#pragma mark - Coupon

@implementation CouponTypeObject
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

//TODO: need implementation

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"coupon_type_id"}];
}
@end

@implementation CouponObject
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

//TODO: need implementation

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"desc",@"id":@"coupon_id"}];
}
@end

@implementation StoreCoupon
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data.coupons":@"coupons",@"data.total_coupons":@"total_coupons"}];
}

- (instancetype)init{
    self = [super init];
    if(self) {
        self.coupons = (NSMutableArray<CouponObject>*)[[NSMutableArray alloc]init];
        _pageindex = 1;
    }
    return self;
}

- (void)addCoupon:(CouponObject *)coupon{
    [self.coupons addObject:coupon];
}

- (void)increasePageIndex:(NSInteger)count{
    self.pageindex += count;
}

- (void)removeAllCoupons{
    [self.coupons removeAllObjects];
    self.pageindex = 1;
}

- (void)removeCoupon:(CouponObject *)coupon{
    [self.coupons removeObject:coupon];
}
@end


#pragma mark - User
@implementation UserModel
-(instancetype)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if (self) {
        self.email = [self null2nil:attributes[@"email"]];
        self.social_id = [self null2nil:[attributes objectForKey:@"social_id"]];
        self.social_type = [[self null2nil:[attributes objectForKey:@"social_type"]] integerValue];
        self.app_id = [[self null2nil:[attributes objectForKey:@"app_id"]] integerValue];
    }
    return self;
}

@end

@implementation UserProfile
-(instancetype)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if (self) {
        self.name = [self null2nil:attributes[@"name"]];
        self.user_id = [[self null2nil:[attributes objectForKey:@"user_id"]] integerValue];
        self.gender = [[self null2nil:[attributes objectForKey:@"gender"]] integerValue];
        self.address = [self null2nil:[attributes objectForKey:@"address"]];
        self.avatar_url = [self null2nil:[attributes objectForKey:@"avatar_url"]];
    }
    return self;
}

@end
#pragma mark - Staff

@implementation StaffObject

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"staff_id"
                                                       }];
//||||||| merged common ancestors
//+(BOOL)propertyIsOptional:(NSString *)propertyName{
//    return YES;
//}
//
//+(JSONKeyMapper*)keyMapper{
//    return [[JSONKeyMapper alloc] initWithDictionary:@{}];
//=======
//-(instancetype)initWithAttributes:(NSDictionary *)attributes{
//    self = [super init];
//    if (self) {
//        self.email = [self null2nil:attributes[@"email"]];
//        self.social_id = [self null2nil:[attributes objectForKey:@"social_id"]];
//        self.social_type = [[self null2nil:[attributes objectForKey:@"social_type"]] integerValue];
//        self.app_id = [[self null2nil:[attributes objectForKey:@"app_id"]] integerValue];
//    }
//    return self;
//>>>>>>> origin/ImplementMenuScreen
}

@end

//<<<<<<< HEAD
@implementation StaffCategory

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!_staffs) {
            _staffs = (NSMutableArray<StaffObject> *)[[NSMutableArray alloc]init];
            _pageindex = 1;
        }
    }
    return self;
}

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"staff_cate_id"
                                                       }];
    
}

- (void)addStaff:(StaffObject *)staff{
    [_staffs addObject:staff];
}

- (void)increaseIndex:(NSInteger)count{
    _pageindex += count;
}

- (void)removeAllStaff{
    [_staffs removeAllObjects];
    _pageindex = 1;
}

@end

@implementation ReserveObject

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"reserve_id"
                                                       }];
    
}

@end
