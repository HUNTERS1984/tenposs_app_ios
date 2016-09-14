//
//  SettingsScreen.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/11/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <InAppSettingsKit/IASKAppSettingsViewController.h>
#import "BaseViewController.h"

@interface SettingsScreen : BaseViewController <IASKSettingsDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end
