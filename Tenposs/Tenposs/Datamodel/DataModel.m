//
//  DataModel.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/2/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "DataModel.h"


@implementation TopObject

@end

#pragma mark - Product
@implementation ProductObject

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
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


@end

#pragma mark - Gallery
@implementation PhotoObject
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
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

@end

#pragma mark - News
@implementation NewsObject
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end

@implementation NewsCategoryObject

- (instancetype)init{
    self = [super init];
    if (self) {
        self->news = (NSMutableArray<NewsObject *> *)[[NSMutableArray alloc]init];
    }
    return self;
}
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}


@end

#pragma mark - Shop
@implementation ShopObject
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}


@end
