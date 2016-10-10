//
//  SideMenuIcon.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/27/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SideMenuIcon : NSObject
+(instancetype)sharedInstance;
+(UIImage*) imageWithIdentifier:(NSString*) identifier;
+(UIImage *)sideMenuImageWithMenuId:(NSInteger)menu_id;
@end
