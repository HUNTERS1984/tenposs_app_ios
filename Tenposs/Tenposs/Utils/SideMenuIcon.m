//
//  SideMenuIcon.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/27/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SideMenuIcon.h"
#import "AppConfiguration.h"

@interface IconRect : NSObject
@property CGRect rect;
-(instancetype) initWithX:(CGFloat) x y:(CGFloat) y width:(CGFloat) width height:(CGFloat)height;
@end

@implementation  IconRect
-(instancetype) initWithX:(CGFloat) x y:(CGFloat) y width:(CGFloat) width height:(CGFloat)height{
    self = [super init];
    self.rect = CGRectMake(x, y, width, height);
    return self;
}
@end


@interface SideMenuIcon()

@property UIImage* icons;

@end

@implementation SideMenuIcon
-(instancetype)init{
    self = [super init];
    self.icons = [UIImage imageNamed:@"icon_side_menu"];
    return self;
}
+(NSDictionary*) identifierMapping{
    static NSDictionary* mapping = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat y = 31;
        CGFloat h = 38;
        CGFloat w = 38;
        CGFloat x = 0;

        mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                   [[IconRect alloc] initWithX:x y:y width:w height:h],@"icon-home",
                   [[IconRect alloc] initWithX:x y:131 width:w height:h],@"icon-menu",
                   [[IconRect alloc] initWithX:x y:231 width:w height:h],@"icon-reserve",
                   [[IconRect alloc] initWithX:x y:331 width:w height:h],@"icon-news",
                   [[IconRect alloc] initWithX:x y:431 width:w height:h],@"icon-photo",
                   [[IconRect alloc] initWithX:x y:531 width:w height:h],@"icon-staff",
                   [[IconRect alloc] initWithX:x y:631 width:w height:h],@"icon-coupon",
                   [[IconRect alloc] initWithX:x y:731 width:w height:h],@"icon-chat",
                   [[IconRect alloc] initWithX:x y:831 width:w height:h],@"icon-setting",
                   nil];
    });
    return mapping;
}
+(instancetype)sharedInstance{
    static SideMenuIcon* moodsIcon = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        moodsIcon = [[SideMenuIcon alloc] init];
    });
    
    return moodsIcon;
}
+(UIImage*) imageWithIdentifier:(NSString*) identifier{
    UIImage* image = nil;
    IconRect* iconRect = [[SideMenuIcon identifierMapping] valueForKey:identifier];
    if( iconRect != nil){
        SideMenuIcon* instance = [SideMenuIcon sharedInstance];
        CGRect cropRegion = iconRect.rect;
        CGImageRef subImage = CGImageCreateWithImageInRect(instance.icons.CGImage, cropRegion);
        image = [UIImage imageWithCGImage:subImage];
    }
    return image;
}

+(UIImage *)sideMenuImageWithMenuId:(NSInteger)menu_id{
    NSString *iconIdentifier = nil;
    switch (menu_id) {
        case APP_MENU_TOP:
            iconIdentifier = @"icon-home";
            break;
        case APP_MENU_CHAT:
            iconIdentifier = @"icon-chat";
            break;
        case APP_MENU_MENU:
            iconIdentifier = @"icon-menu";
            break;
        case APP_MENU_NEWS:
            iconIdentifier = @"icon-news";
            break;
        case APP_MENU_RESERVE:
            iconIdentifier = @"icon-reserve";
            break;
        case APP_MENU_STAFF:
            iconIdentifier = @"icon-staff";
            break;
        case APP_MENU_COUPON:
            iconIdentifier = @"icon-coupon";
            break;
        case APP_MENU_LOGOUT:
            iconIdentifier = @"icon-logout";
            break;
        case APP_MENU_PHOTO_GALLERY:
            iconIdentifier = @"icon-photo";
            break;
        case APP_MENU_SETTING:
            iconIdentifier = @"icon-setting";
            break;
        default:
            return nil;
            break;
    }
    return [SideMenuIcon imageWithIdentifier:iconIdentifier];
}

@end
