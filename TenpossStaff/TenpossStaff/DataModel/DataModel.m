//
//  DataModel.m
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/14/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import "DataModel.h"


@implementation CouponRequestListModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.list_request = (NSMutableArray<CouponRequestModel> *)[NSMutableArray new];
    }
    return self;
}

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

//TODO: need implementation

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"desc"}];
}

- (void)addCouponRequest:(CouponRequestModel *)request{
    if (![_list_request containsObject:request]) {
        [_list_request addObject:request];
    }
}

- (void)increasePageIndex:(NSInteger) count{
    _pageIndex += 1;
}

-(void) removeAllCouponRequests{
    [_list_request removeAllObjects];
    _pageIndex = 0;
}

-(void)removeCouponRequest:(CouponRequestModel *)request{
    [_list_request removeObject:request];
}

@end

@implementation CouponRequestModel

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

//TODO: need implementation

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"request_id"}];
}

- (NSDate *)getRequestDate{
    if (_user_use_date) {
        _request_date = [Utils convertDateFromString:_user_use_date];
        return _request_date;
    }
//    else{
//        if (_request_at && ![_request_at isEqualToString:@""]) {
//            _request_date = [Utils convertDateFromString:_request_at];
//            return _request_date;
//        }else return nil;
//    }
    return nil;
}

@end

@implementation CouponTypeObject
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

//TODO: need implementation

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"coupon_type_id"}];
}
@end

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

#pragma mark - User

@implementation UserModel

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"user_id"}];
}

@end
