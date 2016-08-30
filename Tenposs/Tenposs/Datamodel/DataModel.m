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

- (void)addNews:(NewsObject *)new{
    [self.news addObject:new];
}

- (void)increasePageIndex:(NSInteger)count{
    self.pageIndex += 1;
}

@end

#pragma mark - Store
@implementation ShopObject
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
    self.pageindex = 0;
}

- (void)removeCoupon:(CouponObject *)coupon{
    [self.coupons removeObject:coupon];
}
@end


#pragma mark - User
@implementation UserModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{}];
}

@end

@implementation UserProfile
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"user_id"}];
}

@end
