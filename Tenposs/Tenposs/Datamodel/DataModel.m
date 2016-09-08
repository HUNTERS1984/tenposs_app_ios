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

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
//TODO: need implementation

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"product_id",@"description":@"desc"}];
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
    }
    return self;
}
//TODO: need implementation

+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"category_id", @"data.photos":@"photos", @"data.total_photos":@"total_photos"}];
}

- (void)addPhoto:(PhotoObject *)photo{
    [self.photos addObject:photo];
}

- (void)increasePageIndex:(NSInteger)count{
    self.pageindex += count;
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
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data.news":@"news"}];
}

- (NSString *)title{
    if (_store_id != 0) {
        return [NSString stringWithFormat:@"%@ - %ld",@"Store",(long)_store_id];
    }
    return @"";
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

@end


#pragma mark - Coupon

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
