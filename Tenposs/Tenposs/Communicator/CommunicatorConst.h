//
//  CommunicatorConst.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/6/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString.h"
#import "Bundle.h"

//Backend error
#define ERROR_OK                    1000
#define ERROR_NO_CHARACTER          9993
#define ERROR_POINT                 9994
#define ERROR_USER_NOT_VALIDATE     9995
#define ERROR_USER_EXISTED          9996
#define ERROR_INVALID_METHOD        9997
#define ERROR_INVALID_TOKEN         9998
#define ERROR_EXCEPTION             9999
#define ERROR_DATABASE              1001
#define ERROR_MISSING_PARAMS        1002
#define ERROR_WRONG_PARAMS          1003
#define ERROR_INVALID_PARAMS        1004
#define ERROR_UNKNOWN               1005
#define ERROR_EMAIL_NOT_CORRECT     1006
#define ERROR_ADDRESS_NOT_EXIST     1007
#define ERROR_CANNOT_SEND_EMAIL     1008
#define ERROR_ACCOUNT_NOT_ACTIVE    1009
#define ERROR_CREATE_ROOM_SUCCESS   1010
#define ERROR_TIME_EXPIRE           1011
#define ERROR_SIG_NOT_EXIST         1012
#define ERROR_SIG_INVALID           1013

//Client error
#define ERROR_JSON_PARSER               901
#define ERROR_CONTENT_FULLY_LOADED      902
#define ERROR_NO_CONTENT                903
#define ERROR_DATASOURCE_IS_LAST        904
#define ERROR_DATASOURCE_IS_FIRST       905
#define ERROR_DATASOURCE_IS_DUBLICATED  906

#define ERROR_NO_CHARACTER_Message          @"No character is registed on server"
#define ERROR_POINT_Message                 @"Point is not enought"
#define ERROR_USER_EXISTED_Message          @"User existed."
#define ERROR_USER_NOT_VALIDATE_Message     @"User is not validated."
#define ERROR_INVALID_METHOD_Message        @"Method is not valid."
#define ERROR_INVALID_TOKEN_Message         @"invalid token"
#define ERROR_EXCEPTION_Message             @"Lỗi exception"
#define ERROR_DATABASE_Message              @"Lõi mất kết nối DB/hoac thuc thi cau SQL"
#define ERROR_MISSING_PARAMS_Message        @"Số lượng Paramater không đầy đủ"
#define ERROR_WRONG_PARAMS_Message          @"Kieu Parameter không đúng đắn."
#define ERROR_INVALID_PARAMS_Message        @"Value cua parameter khong hop le"
#define ERROR_UNKNOWN_Message               @"Unknown error"
#define ERROR_EMAIL_NOT_CORRECT_Message     @"Email not correct"
#define ERROR_ADDRESS_NOT_EXIST_Message     @"Address does not exits"
#define ERROR_CANNOT_SEND_EMAIL_Message     @"Can not send email"
#define ERROR_ACCOUNT_NOT_ACTIVE_Message    @"Account is not active"
#define ERROR_CREATE_ROOM_SUCCESS_Message   @"Create Room Success"
#define ERROR_TIME_EXPIRE_Message           @"Time expire"
#define ERROR_SIG_NOT_EXIST_Message         @"Parameter sig not exist"
#define ERROR_SIG_INVALID_Message           @"Parameter sig is not valid"


@interface CommunicatorConst : NSObject

+(NSString *)getErrorMessage:(NSInteger)errorCode;

@end
