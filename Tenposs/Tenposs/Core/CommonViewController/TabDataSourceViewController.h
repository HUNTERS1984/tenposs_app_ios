//
//  TabDataSourceViewController.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TABVIEWCONTROLLER_Menu      @"MenuScreen"
#define TABVIEWCONTROLLER_News      @"NewsScreen"
#define TABVIEWCONTROLLER_Gallery   @"GalleryScreen"
#define TABVIEWCONTROLLER_Staff     @"StaffScreen"

@interface TabDataSourceViewController : UIViewController <UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
@property(strong, nonatomic) UINavigationController *mainNavigationController;
@property(strong, nonatomic) NSString *controllerType;

- (void)setControllerType:(NSString *)controllerType;

@end
