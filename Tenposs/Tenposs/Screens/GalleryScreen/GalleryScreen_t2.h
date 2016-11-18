//
//  GalleryScreen_t2.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/15/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryScreenDetailDataSource.h"
#import "RFQuiltLayout.h"

@interface GalleryScreen_t2 : UIViewController <RFQuiltLayoutDelegate, SimpleDataSourceDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) GalleryScreenDetailDataSource *dataSource;

@end
