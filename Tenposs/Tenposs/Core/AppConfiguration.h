//
//  AppConfiguration.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/26/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppConfiguration : NSObject

+ (instancetype) sharedInstance;

/*
 *  CollectionView properties
 */
@property (assign, nonatomic) CGFloat cellSpacing;
@property (assign, nonatomic) NSInteger numberOfProductColumn_iphone;
@property (assign, nonatomic) NSInteger numberOfProductColumn_ipad;
@property (assign, nonatomic) NSInteger numberOfPhotoColumn_iphone;
@property (assign, nonatomic) NSInteger numberOfPhotoColumn_ipad;

/*
 *  Navigation bar properties
 */
@property (strong, nonatomic) UIColor *navBackgroundColor;
@property (strong, nonatomic) UIColor *navTextColor;
@property (assign, nonatomic) CGFloat navTextSize;
@property (strong, nonatomic) UIColor *navMenuIconColor;
@property (strong, nonatomic) NSString *navFontFamily;

/*
 *  Menu properties
 */
@property (strong, nonatomic) UIColor *menuBackgroundColor;
@property (strong, nonatomic) UIColor *menuTextColor;
@property (assign, nonatomic) CGFloat menuTextSize;
@property (strong, nonatomic) NSString *menuFontFamily;

@end
