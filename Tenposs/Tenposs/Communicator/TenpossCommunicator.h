//
//  TenpossCommunicator.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/28/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bundle.h"


#define KeyRequestTimeout			@"KeyRequestTimeout"
#define KeyRequestURL               @"KeyRequestURL"
#define KeyRequestRetry             @"KeyRequestRetry"
/**
 *  Key for upload data
 **/
#define KeyRequestData              @"KeyRequestData"
/**
 *  Key for request object
 **/
#define KeyRequestNeedReloadIfError    @"KeyRequestNeedReloadIfError"
#define KeyRequestObject            @"KeyRequestObject"
#define KeyRequestExtra             @"KeyRequestExtra"
#define KeyRequestExtraData         @"KeyRequestExtraData"

#define KeyResponseError            @"KeyResponseError"
#define KeyResponseData             @"KeyResponseData"
#define KeyResponseObject           @"KeyResponseObject"
#define KeyResponseResult           @"KeyResponseResult"
#define KeyResponseResultFromNetwork @"KeyResponseResultFromNetwork"
#define KeyResponseResultFromAPI @"KeyResponseResultFromAPI"

typedef NS_ENUM(NSInteger, TenpossErrorCode){
    //Application Define
    ResultErrorConnection = -1,
    
    
    ResultSuccess = 1000,//	OK
    ResultErrorNoCharacterRegisted = 9993,//		No character is registed on
    ResultErrorPoinyNotEnough = 9994,//		Point is not enought
    ResultErrorUserNotValidated = 9995,//		User is not validated.
    ResultErrorUserNotExisted = 9996,//		User existed.
    ResultErrorMethodNotValid = 9997,//		Method is not valid.
    ResultErrorInvalidToken = 9998,//		invalid token
    ResultErrorException = 9999,//		Lỗi exception
    ResultErrorDBConnection = 1001,//		Lõi mất kết nối DB/hoac thuc thi
    ResultErrorMissingParameters = 1002,//		Số lượng Paramater không đầy đủ
    ResultErrorInvalidParameters = 1003,//		Kieu Parameter không đúng đắn.
    ResultErrorInvalidValue = 1004,//		Value cua parameter khong hop le
    ResultErrorUnknown = 1005,//		Unknown error

};

@class TenpossCommunicator;
@class Bundle;
@protocol TenpossCommunicatorDelegate <NSObject>
@required
- (void)        completed:(TenpossCommunicator*)request data:(Bundle*) responseParams;
- (void)        begin:(TenpossCommunicator*)request data:(Bundle*) responseParams;
-( void)        cancelAllRequest;

@optional
- (void)        receving:(TenpossCommunicator*)request completed:(NSInteger) completed total:(NSInteger) total;
@end


@interface TenpossCommunicator: NSObject<NSURLSessionDelegate>
{
    NSMutableURLRequest *m_pRequest;
    NSURLConnection * m_pConnection;
    Bundle* m_pParams;
}
@property NSInteger httpCode;
@property NSMutableData* responseData;
@property BOOL cancelled;
@property (nonatomic, weak) id<TenpossCommunicatorDelegate> delegate;

-(void)     customPrepare:(Bundle*) params;
-(void)     customProcess:(Bundle*) params;

-(void)     execute:(Bundle*) params withDelegate:(id) delegate;
-(void)     cancelRequest;

@end