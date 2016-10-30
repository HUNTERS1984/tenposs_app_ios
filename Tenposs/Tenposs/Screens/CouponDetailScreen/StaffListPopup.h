//
//  StaffListPopup.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/27/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@protocol StaffListPopupDelegate <NSObject>

- (void)staffChose:(StaffObject *)staff;

@end

@interface StaffListPopup : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) id<StaffListPopupDelegate>delegate;

@end
