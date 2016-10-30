//
//  SettingsEditProfileScreen.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/26/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SET_EDIT_AVATAR     @0
#define SET_EDIT_USER_ID    @1
#define SET_EDIT_USER_NAME  @2
#define SET_EDIT_EMAIL      @3
#define SET_EDIT_GENDER     @4
#define SET_EDIT_PROVINCE   @5
#define SET_EDIT_FACEBOOK   @6
#define SET_EDIT_TWITTER    @7
#define SET_EDIT_INSTAGRAM  @8

#define NOTI_SET_EDIT_CHANGED   @"editprofilesettingchanged"


@interface SettingsEditProfileScreen : UITableViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>



@end
