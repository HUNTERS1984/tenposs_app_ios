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
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"photo_id",@"categoryid":@"category_id",@"categoryname":@"category_name"}];
}
@end

@implementation GalleryObject
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}


- (instancetype)init{
    self = [super init];
    if (self) {
        self->photos = (NSMutableArray<PhotoObject *> *)[[NSMutableArray alloc]init];
    }
    return self;
}
//TODO: need implementation

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{}];
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

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data.news":@"news"}];
}

- (void)addNews:(NewsObject *)new{
    [self.news addObject:new];
}
@end

#pragma mark - Shop
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
