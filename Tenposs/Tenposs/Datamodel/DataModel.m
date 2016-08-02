//
//  DataModel.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/2/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "DataModel.h"

#pragma mark - Product
@implementation ProductObject

@end

@implementation ProductCategoryObject

- (instancetype)init{
    self = [super init];
    if (self) {
        self->products = (NSMutableArray<ProductObject *> *)[[NSMutableArray alloc]init];
    }
    return self;
}

@end

#pragma mark - Gallery
@implementation PhotoObject

@end

@implementation GalleryObject

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

@end

@implementation NewsCategoryObject

- (instancetype)init{
    self = [super init];
    if (self) {
        self->news = (NSMutableArray<NewsObject *> *)[[NSMutableArray alloc]init];
    }
    return self;
}

@end

#pragma mark - Shop
@implementation ShopObject

@end
