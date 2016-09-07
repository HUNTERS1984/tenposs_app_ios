//
//  CommunicatorConst.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/6/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "CommunicatorConst.h"

@implementation CommunicatorConst

+(NSString *)getErrorMessage:(NSInteger)errorCode{
    //TODO: CommunicatorConst - need implement
    NSString *message = @"";
    
    if ( errorCode == ERROR_OK){
        message = @"";
    }else if ( errorCode == ERROR_NO_CHARACTER){
        message = ERROR_NO_CHARACTER_Message;
    }else if ( errorCode == ERROR_POINT){
        message = ERROR_POINT_Message;
    }else if ( errorCode == ERROR_USER_NOT_VALIDATE){
        message = ERROR_USER_NOT_VALIDATE_Message;
    }else if ( errorCode == ERROR_USER_EXISTED){
        message = ERROR_USER_EXISTED_Message;
    }else if ( errorCode == ERROR_INVALID_METHOD){
        message = ERROR_INVALID_METHOD_Message;
    }else if ( errorCode == ERROR_INVALID_TOKEN){
        message = ERROR_INVALID_TOKEN_Message;
    }else if ( errorCode == ERROR_EXCEPTION){
        message = ERROR_EXCEPTION_Message;
    }else if ( errorCode == ERROR_DATABASE){
        message = ERROR_DATABASE_Message;
    }else if ( errorCode == ERROR_MISSING_PARAMS){
        message = ERROR_MISSING_PARAMS_Message;
    }else if ( errorCode == ERROR_WRONG_PARAMS){
        message = ERROR_WRONG_PARAMS_Message;
    }else if ( errorCode == ERROR_INVALID_PARAMS){
        message = ERROR_INVALID_PARAMS_Message;
    }else if ( errorCode == ERROR_UNKNOWN){
        message = ERROR_UNKNOWN_Message;
    }else if ( errorCode == ERROR_EMAIL_NOT_CORRECT){
        message = ERROR_EMAIL_NOT_CORRECT_Message;
    }else if ( errorCode == ERROR_ADDRESS_NOT_EXIST){
        message = ERROR_ADDRESS_NOT_EXIST_Message;
    }else if ( errorCode == ERROR_CANNOT_SEND_EMAIL){
        message = ERROR_CANNOT_SEND_EMAIL_Message;
    }else if ( errorCode == ERROR_ACCOUNT_NOT_ACTIVE){
        message = ERROR_ACCOUNT_NOT_ACTIVE_Message;
    }else if ( errorCode == ERROR_CREATE_ROOM_SUCCESS){
        message = ERROR_CREATE_ROOM_SUCCESS_Message;
    }else if ( errorCode == ERROR_TIME_EXPIRE){
        message = ERROR_TIME_EXPIRE_Message;
    }else if ( errorCode == ERROR_SIG_NOT_EXIST){
        message = ERROR_SIG_NOT_EXIST_Message;
    }else if ( errorCode == ERROR_SIG_INVALID){
        message = ERROR_SIG_INVALID_Message;
    }
    
    return message;
}

@end
