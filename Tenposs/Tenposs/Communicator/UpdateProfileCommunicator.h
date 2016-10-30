//
//  UpdateProfileCommunicator.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/28/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TenpossCommunicator.h"


#define NOTI_UPDATE_PROFILE_REQUEST @"notificationupdateprofilerequest"


@interface UpdateProfileCommunicator : NSObject<NSURLSessionDelegate>{
    NSMutableURLRequest *m_pRequest;
    NSURLConnection * m_pConnection;
}
@property NSInteger httpCode;
@property NSMutableData* responseData;
@property BOOL cancelled;
@property (strong, nonatomic) NSString *request_url;

-(void) execute:(id) parameters;

@end
