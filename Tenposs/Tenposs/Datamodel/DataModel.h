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

@protocol ProductObject
@end

@protocol ProductContainer <NSObject>
@required
-(void)addProduct:(ProductObject *)product;
@optional
-(void)removeAllProduct;
-(void)removeProduct:(ProductObject *)productToRemove;
@end

@protocol PhotoObject
@end

@protocol NewsObject
@end

@protocol ShopObject
@end

@protocol TopObject
@end

#pragma mark - TopItem
@interface TopObject: JSONModel
@property (strong, nonatomic)NSString *image_url;
@end

#pragma mark - Product
@interface ProductObject : JSONModel
@property (assign, nonatomic) NSInteger product_id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *image_url;
@property (strong, nonatomic) ProductCategoryObject *parentCategory;

- (void)updateItemWithItem:(ProductObject *)item;

@end

@interface ProductCategoryObject : JSONModel{
    @public
    NSMutableArray<ProductObject *> *products;
}
@property (strong, nonatomic)NSString *categoryName;
@end

#pragma mark - News
@interface NewsObject : JSONModel
@property (assign, nonatomic) NSInteger news_id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *image_url;
@property (strong, nonatomic) NSString *date;
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
@property (assign, nonatomic) NSInteger photo_id;
@property (assign, nonatomic) NSInteger category_id;
@property (strong, nonatomic) NSString *category_name;
@property (strong, nonatomic) NSString *image_url;
@end

@interface GalleryObject : JSONModel{
    @public
    NSMutableArray<PhotoObject *> *photos;
}
@property (strong, nonatomic) NSString *galleryName;

@end
#pragma mark - Shop
@interface ShopObject : JSONModel
@property (assign, nonatomic) NSInteger shopId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *tel;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *start_time;
@property (strong, nonatomic) NSString *end_time;

@end

