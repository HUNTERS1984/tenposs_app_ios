//
//  GalleryScreenDetailDataSource.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/21/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"
#import "SimpleDataSource.h"
#import "PhotoCommunicator.h"

@interface GalleryScreenDetailDataSource : SimpleDataSource

@property(strong, nonatomic) PhotoCategory *mainData;

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate andPhotoCategory:(PhotoCategory *)category;

@end
