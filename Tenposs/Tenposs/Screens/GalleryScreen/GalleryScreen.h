//
//  GalleryScreen.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/21/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "BaseViewController.h"

@interface GalleryScreen : BaseViewController
@property UINavigationController *mainNavigationController;
- (void)showPhoto:(PhotoObject *)photoObject;
@end
