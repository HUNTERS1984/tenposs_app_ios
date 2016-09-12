//
//  PhotoViewer.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/31/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface PhotoViewer : UIViewController

- (void)setPhoto:(PhotoObject *)photo;

- (void) presentPhoto:(PhotoObject *)photo;

@end
