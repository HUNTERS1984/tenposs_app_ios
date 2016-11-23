//
//  BasicCollectionViewController.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleDataSource.h"
#import "UIViewController+LoadingView.h"
#import "GlobalMapping.h"
#import "DataModel.h"

@interface BasicCollectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,SimpleDataSourceDelegate>
@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property (strong, nonatomic) SimpleDataSource *dataSource;
@property(strong, nonatomic) UIColor *bkgColor;

//-(instancetype)initWithDataSource:(SimpleDataSource *)dataSource;

@end
