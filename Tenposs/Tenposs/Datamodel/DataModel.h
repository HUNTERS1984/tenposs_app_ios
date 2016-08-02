//
//  DataModel.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/2/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductObject;
@class PhotoObject;
@class NewsObject;
@class ShopObject;
@class ProductCategoryObject;
@class NewsCategoryObject;

#pragma mark - Product
@interface ProductObject : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) ProductCategoryObject *parentCategory;
@end

@interface ProductCategoryObject : NSObject{
    @public
    NSMutableArray<ProductObject *> *products;
}
@property (strong, nonatomic)NSString *categoryName;
@end

#pragma mark - News
@interface NewsObject : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NewsCategoryObject *parentCategory;
@end

@interface NewsCategoryObject : NSObject{
    @public
    NSMutableArray<NewsObject *> *news;
}
@property (strong, nonatomic) NSString *categoryName;
@end


#pragma mark - Gallery
@interface PhotoObject : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@end

@interface GalleryObject : NSObject{
    @public
    NSMutableArray<PhotoObject *> *photos;
}
@property (strong, nonatomic) NSString *galleryName;

@end
#pragma mark - Shop
@interface ShopObject : NSObject

@property (strong, nonatomic) NSString *shopName;
@property (strong, nonatomic) NSString *shopAddress;
@property (strong, nonatomic) NSString *shopAddressLong;
@property (strong, nonatomic) NSString *shopAddressLat;
@property (strong, nonatomic) NSString *shopPhoneNumber;
@property (strong, nonatomic) NSString *shopOpenHour;

@end

