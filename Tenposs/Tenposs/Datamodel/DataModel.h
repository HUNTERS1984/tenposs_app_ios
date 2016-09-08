//
//  DataModel.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/2/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "EntityBase.h"

@class ProductObject;
@class PhotoObject;
@class NewsObject;
@class ContactObject;
@class ProductCategoryObject;
@class NewsCategoryObject;
@class PhotoCategory;
@class AllPhotoCategory;

@protocol ProductObject
@end

@protocol ProductContainer <NSObject>
@required
-(void)addProduct:(ProductObject *)product;
-(void)increasePageIndex:(NSInteger)count;
@optional
-(void)removeAllProduct;
-(void)removeProduct:(ProductObject *)productToRemove;
@end

@protocol NewsContainer <NSObject>
@required
-(void)addNews:(NewsObject *)ne;
-(void)increasePageIndex:(NSInteger)count;
@optional
-(void)removeAllNews;
-(void)removeNews:(NewsObject *)news;
@end

@protocol PhotoContainer <NSObject>
@required
- (void)addPhoto:(PhotoObject *)photo;
-(void)increasePageIndex:(NSInteger)count;
@optional
-(void)removeAllPhotos;
-(void)removePhoto:(PhotoObject *)photo;
@end

@protocol PhotoObject
@end

@protocol NewsObject
@end

@protocol TopObject
@end

@protocol PhotoCategory
@end

@protocol ContactObject
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
@property(strong, nonatomic) NSMutableArray <ConvertOnDemand, ProductObject> *rel_items;
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
@property(assign, nonatomic) NSInteger store_id;
@property (strong, nonatomic) NewsCategoryObject *parentCategory;
@end

@interface NewsCategoryObject : JSONModel <NewsContainer>{
    @public
}
@property (assign, nonatomic) NSInteger store_id;
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) NSInteger totalnew;
@property (strong, nonatomic) NSMutableArray<ConvertOnDemand,NewsObject> *news;
- (NSString *)title;
@end


#pragma mark - Gallery
@interface PhotoObject : JSONModel
@property (assign, nonatomic) NSInteger photo_id;
@property (assign, nonatomic) NSInteger category_id;
@property (strong, nonatomic) NSString *category_name;
@property (strong, nonatomic) NSString *image_url;
@property (strong, nonatomic) NSString *updated_at;
@property (strong, nonatomic) NSString *created_at;
@end

@interface PhotoCategory : JSONModel <PhotoContainer>
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger category_id;
@property (strong, nonatomic) NSMutableArray<ConvertOnDemand, PhotoObject> *photos;
@property (assign, nonatomic) NSInteger total_photos;
@property (assign, nonatomic) NSInteger pageindex;
@property (assign, nonatomic) NSInteger pagesize;
@end

@interface AllPhotoCategory : JSONModel
@property (strong, nonatomic) NSMutableArray<ConvertOnDemand, PhotoCategory> *photo_categories;
@end

#pragma mark - Shop
@interface ContactObject : JSONModel
@property (assign, nonatomic) NSInteger shopId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *tel;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *start_time;
@property (strong, nonatomic) NSString *end_time;
@end

#pragma mark - Coupon

@class CouponObject;

@protocol CouponObject
@end

@protocol CouponContainer <NSObject>

@required
- (void)addCoupon:(CouponObject *)coupon;
- (void)increasePageIndex:(NSInteger) count;
@optional
-(void) removeAllCoupons;
-(void)removeCoupon:(CouponObject *)coupon;
@end

@interface CouponObject : JSONModel

@property (assign, nonatomic) NSInteger coupon_id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *image_url;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic) NSString *start_date;
@property (strong, nonatomic) NSString *end_date;
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *updated_at;
@property (assign, nonatomic) NSInteger store_id;

@end

@interface StoreCoupon : JSONModel <CouponContainer>
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *message;
@property (assign, nonatomic) NSInteger pageindex;
@property (assign, nonatomic) NSInteger pagesize;
@property (assign, nonatomic) NSInteger store_id;
@property (assign, nonatomic) NSInteger total_coupons;
@property (strong, nonatomic) NSMutableArray <CouponObject, ConvertOnDemand> * coupons;
@end

#pragma mark - User
@class UserProfile;
@class UserModel;

@interface UserModel: EntityBase
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *social_id;
@property (assign, nonatomic) NSInteger social_type;
@property (assign, nonatomic) NSInteger app_id;
@property (strong, nonatomic) UserProfile *profile;
@end

@interface UserProfile : EntityBase
@property (assign, nonatomic) NSInteger user_id;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger gender;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *avatar_url;
@property (assign, nonatomic) NSInteger facebook_status;
@property (assign, nonatomic) NSInteger twitter_status;
@property (assign, nonatomic) NSInteger instagram_status;
@end
