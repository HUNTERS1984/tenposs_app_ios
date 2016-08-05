//
//  DataModel.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/2/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@class ProductObject;
@class PhotoObject;
@class NewsObject;
@class ShopObject;
@class ProductCategoryObject;
@class NewsCategoryObject;

#pragma mark - TopItem
@interface TopObject: JSONModel
@property (strong, nonatomic)NSString *thumbURL;
@end

#pragma mark - Product
@interface ProductObject : JSONModel
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *thumbURL;
@property (strong, nonatomic) ProductCategoryObject *parentCategory;
@end

@interface ProductCategoryObject : JSONModel{
    @public
    NSMutableArray<ProductObject *> *products;
}
@property (strong, nonatomic)NSString *categoryName;
@end

#pragma mark - News
@interface NewsObject : JSONModel
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NewsCategoryObject *parentCategory;
@end

@interface NewsCategoryObject : JSONModel{
    @public
    NSMutableArray<NewsObject *> *news;
}
@property (strong, nonatomic) NSString *categoryName;
@end


#pragma mark - Gallery
@interface PhotoObject : JSONModel
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@end

@interface GalleryObject : JSONModel{
    @public
    NSMutableArray<PhotoObject *> *photos;
}
@property (strong, nonatomic) NSString *galleryName;

@end
#pragma mark - Shop
@interface ShopObject : JSONModel

@property (strong, nonatomic) NSString *shopName;
@property (strong, nonatomic) NSString *shopAddress;
@property (strong, nonatomic) NSString *shopAddressLong;
@property (strong, nonatomic) NSString *shopAddressLat;
@property (strong, nonatomic) NSString *shopPhoneNumber;
@property (strong, nonatomic) NSString *shopOpenHour;

@end

