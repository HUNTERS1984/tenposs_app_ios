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

@protocol ProductSizeObject
@end

@protocol ReserveObject
@end

@class ProductSizeObject;

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
@property (strong, nonatomic) NSString *item_link;
@property (strong, nonatomic) NSString *menu;
@property (strong, nonatomic) NSMutableArray <ConvertOnDemand, ProductSizeObject> *size;
@property (strong, nonatomic) ProductCategoryObject *parentCategory;
@property(strong, nonatomic) NSMutableArray <ConvertOnDemand, ProductObject> *rel_items;
@property (strong, nonatomic) NSMutableArray *sizeArray;
- (void)updateItemWithItem:(ProductObject *)item;
- (NSMutableArray *)getSizeArray;
@end

@interface ProductCategoryObject : JSONModel{
    @public
    NSMutableArray<ProductObject *> *products;
}
@property (strong, nonatomic)NSString *categoryName;
@end

@interface ProductSizeObject : JSONModel

@property (assign, nonatomic)NSInteger item_size_type_id;
@property (assign, nonatomic)NSInteger item_size_category_id;
@property (strong, nonatomic)NSString *item_size_type_name;
@property (strong, nonatomic)NSString *item_size_category_name;
@property (strong, nonatomic)NSString *value;
@end

#pragma mark - News

@protocol NewsCategoryObject
@end

@interface NewsObject : JSONModel
@property (assign, nonatomic) NSInteger news_id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *image_url;
@property (strong, nonatomic) NSString *date;
@property(assign, nonatomic) NSInteger store_id;
@property (strong, nonatomic) NewsCategoryObject *parentCategory;
@end

@interface NewsCategoryObject : JSONModel <NewsContainer>
@property (assign, nonatomic) NSInteger category_id;
@property (assign, nonatomic) NSInteger store_id;
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) NSInteger totalnew;
@property (strong, nonatomic) NSString *name;
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
@property (strong, nonatomic) NSString *start_time_string;
@property (strong, nonatomic) NSString *end_time_string;

- (NSString *)getEndTimeString;

- (NSString *)getStartTimeString;

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

@interface CouponTypeObject : JSONModel

@property (assign, nonatomic) NSInteger coupon_type_id;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger store_id;

@end

@interface CouponObject : JSONModel

#define COUPON_STATUS_AVAILABLE 1
#define COUPON_STATUS_UNAVAILABLE 0

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
@property (assign, nonatomic) NSInteger can_use;
@property (strong, nonatomic) NSMutableArray<NSString *>   *taglist;
@property (strong, nonatomic) CouponTypeObject *coupon_type;

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


@class StaffObject;

@protocol StaffObject
@end
@protocol StaffCategory
@end

@protocol StaffContainer <NSObject>
-(void)addStaff:(StaffObject *)staff;
-(void)increaseIndex:(NSInteger)count;
-(void)removeAllStaff;
@end

#pragma mark - Staff

@interface StaffObject : JSONModel

@property (assign, nonatomic) NSInteger staff_id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *image_url;
@property (strong, nonatomic) NSString *introduction;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *tel;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *updated_at;
@property (strong, nonatomic) NSString *deleted_at;
@property (assign, nonatomic) NSInteger staff_category_id;

@end

@interface StaffCategory : JSONModel <StaffContainer>

@property (assign, nonatomic)  NSInteger staff_cate_id;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger pageindex;
@property (assign, nonatomic) NSInteger pagesize;
@property (assign, nonatomic) NSInteger total_staffs;
@property(strong, nonatomic) NSMutableArray <StaffObject, ConvertOnDemand> *staffs;

@end

@interface ReserveObject : JSONModel

@property (assign, nonatomic) NSInteger reserve_id;
@property (strong, nonatomic) NSString *reserve_url;
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *updated_at;

@end
