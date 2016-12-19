//
//  SettingHomeScreen.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/25/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UIViewController+LoadingView.h"

#define SKEY_EDIT           @"sKeyEditProfile"
#define SKEY_PUSH           @"sKeyPushNotification"
#define SKEY_COMPANY_INFO   @"sKeyCompanyInfo"
#define SKEY_USER_PRIVACY   @"sKeyUserPrivacy"

#define SKEY_PUSH_COUPON      @"push_status_coupon"
#define SKEY_PUSH_NEWS        @"push_status_news"
#define SKEY_PUSH_CHAT        @"push_status_chat"
#define SKEY_PUSH_RANKING     @"push_status_ranking"

#define SVALUE_ON       @"on"
#define SVALUE_OFF      @"off"


@interface SettingHomeScreen : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
