//
//  Const.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/28/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_ID  @"2a33ba4ea5c9d70f9eb22903ad1fb8b2"
#define APP_SECRET  @"33d3afaeefdffe55b185359f901d15e4"

#define SETTINGS_KeyUserAvatar  @"KeyUserAvatar"
#define SETTINGS_KeyUserID  @"KeyUserID"
#define SETTINGS_KeyUsername  @"KeyUsername"
#define SETTINGS_KeyUserEmail  @"KeyUserEmail"
#define SETTINGS_KeyUserGender  @"KeyUserGender"
#define SETTINGS_KeyUserProvine  @"KeyUserProvine"
#define SETTINGS_KeyUserInstaAccessToken @100

#define SETTINGS_keyPushNotification  @"keyPushNotification"
#define SETTINGS_keyCouponPushNotification  @"keyCouponPushNotification"

#define NOTI_COUPON_REQUEST             @"notification_coupon_user_request"
#define NOTI_COUPON_REQUEST_SUCCESS     @"success"
#define NOTI_COUPON_REQUEST_FAILED      @"failed"

///CellSpanType to define how much space a cell should takes
typedef NS_ENUM(NSInteger, CellSpanType) {
    CellSpanTypeSmall,
    CellSpanTypeNormal,
    CellSpanTypeLarge,
    CellSpanTypeFull,
    CellSpanTypeNone,
};

@interface Const : NSObject

+ (NSInteger)getNumberOfCellPerRowForCellSpanType:(CellSpanType)spanType;

@end
