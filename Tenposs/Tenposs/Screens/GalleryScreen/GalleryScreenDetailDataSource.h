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

#define GalleryScreenDetailError_fullyLoaded    @"Loaded all records"

@interface GalleryScreenDetailDataSource : SimpleDataSource

@property(strong, nonatomic) PhotoCategory *mainData;

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate andPhotoCategory:(PhotoCategory *)menuCategory;

@end
