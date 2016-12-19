//
//  DataModel.h
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/14/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "Utils.h"

@class CouponObject;
@class CouponRequestModel;
@class UserModel;

@protocol CouponObject
@end

@protocol CouponRequestModel
@end

@protocol CouponRequestContainer <NSObject>
@required
- (void)addCouponRequest:(CouponRequestModel *)request;
- (void)increasePageIndex:(NSInteger) count;
@optional
-(void) removeAllCouponRequests;
-(void)removeCouponRequest:(CouponRequestModel *)request;
@end

@interface CouponRequestListModel : JSONModel <CouponRequestContainer>

@property(strong, nonatomic) NSMutableArray <ConvertOnDemand, CouponRequestModel> *list_request;
@property(assign, nonatomic) NSInteger total;
@property(assign, nonatomic) NSInteger pageIndex;
@end

@interface CouponRequestModel : JSONModel

//@property(assign, nonatomic) NSInteger request_id;
//@property(strong, nonatomic) NSString * status; // approved || reject || need_action
//@property(strong, nonatomic) NSString * request_at;
//@property(strong, nonatomic) CouponObject * coupon;
//@property(strong, nonatomic) UserModel *user;
@property (strong, nonatomic) NSDate *request_date;

@property (assign, nonatomic) NSInteger coupon_id;
@property (assign, nonatomic) NSInteger app_user_id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *image_url;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *user_use_date;

- (NSDate *)getRequestDate;

@end

//@protocol CouponContainer <NSObject>
//
//@required
//- (void)addCoupon:(CouponObject *)coupon;
//- (void)increasePageIndex:(NSInteger) count;
//@optional
//-(void) removeAllCoupons;
//-(void)removeCoupon:(CouponObject *)coupon;
//@end

@interface CouponTypeObject : JSONModel

@property (assign, nonatomic) NSInteger coupon_type_id;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger store_id;

@end

@interface CouponObject : JSONModel

#define COUPON_STATUS_AVAILABLE 1
#define COUPON_STATUS_UNAVAILABLE 0

@property (assign, nonatomic) NSInteger     coupon_id;
@property (strong, nonatomic) NSString      *title;
@property (strong, nonatomic) NSString      *desc;
@property (strong, nonatomic) NSString      *image_url;
@property (assign, nonatomic) NSInteger     type;
@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic) NSString *start_date;
@property (strong, nonatomic) NSString *end_date;
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *updated_at;
@property (assign, nonatomic) NSInteger store_id;
@property (assign, nonatomic) bool can_use;
@property (strong, nonatomic) NSMutableArray<NSString *>*taglist;
@property (strong, nonatomic) CouponTypeObject *coupon_type;

@end

#pragma mark - User

@interface UserModel : JSONModel

@property (assign, nonatomic) NSInteger user_id;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *province;

@end
