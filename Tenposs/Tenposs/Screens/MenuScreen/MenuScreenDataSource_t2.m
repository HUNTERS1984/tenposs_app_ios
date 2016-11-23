//
//  MenuScreenDataSource_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "MenuScreenDataSource_t2.h"
#import "BasicCollectionViewController.h"
#import "HexColors.h"
#import "MenuScreenDetailDataSource.h"
#import "AppConfiguration.h"

@interface MenuScreenDataSource_t2()

@property (strong, nonatomic) NSMutableArray *menuCategories;
@property (strong, nonatomic) NSMutableDictionary *cachedViewControllers;
@property (strong, nonatomic) BasicCollectionViewController *activeViewController;
@property (assign, nonatomic) NSInteger activeViewControllerIndex;
@property (nonatomic,copy) MenuScreenLoadedHandler menuCategoryCompleteHandler;

@end

@implementation MenuScreenDataSource_t2

#pragma mark - ViewPagerDataSource

- (void)fetchDataWithCompleteHandler:(MenuScreenLoadedHandler)handler{
    _menuCategoryCompleteHandler = handler;
    [self loadMenuCategoryList];
}

- (MenuCategoryModel *)menuCategoryForTabAtIndex:(NSUInteger)index{
    if (_menuCategories) {
        MenuCategoryModel *cate = [_menuCategories objectAtIndex:index];
        return cate;
    }
    return nil;
}

- (NSString *)titleForTabAtIndex:(NSUInteger)index{
    MenuCategoryModel *cate = [self menuCategoryForTabAtIndex:index];
    if (cate) {
        return cate.name;
    }
    return @"";
}

- (BasicCollectionViewController *)viewControllerForIndex:(NSInteger)index{
    BasicCollectionViewController *viewController;
    MenuCategoryModel *cate = [self menuCategoryForTabAtIndex:index];
    if (cate) {
        NSInteger cateId = cate.menu_id;
        viewController = (BasicCollectionViewController *)[_cachedViewControllers objectForKey:@(cateId)];
        if (!viewController) {
            
            MenuScreenDetailDataSource *detailDataSource = [[MenuScreenDetailDataSource alloc]initWithMenuCategory:cate];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_t2" bundle:nil];
            viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BasicCollectionViewController class])];
            viewController.dataSource = detailDataSource;
            viewController.bkgColor = [UIColor colorWithHexString:@"#FFFFFF"];
            viewController.mainNavigationController = _mainNavigationController;
            if(!_cachedViewControllers){
                _cachedViewControllers = [NSMutableDictionary new];
            }
            [_cachedViewControllers setObject:viewController forKey:@(cateId)];
        }
    }
    return viewController;
}

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager{
    return _menuCategories?[_menuCategories count]:0;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index{
    UILabel *label = [[UILabel alloc] init];
    label.text = [self titleForTabAtIndex:index];
    label.textColor = [UIColor colorWithHexString:@"999999"];
    label.backgroundColor = [UIColor clearColor];
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index{
    return [self viewControllerForIndex:index];
}

#pragma mark - ViewPagerDelegate
- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index{
    self.activeViewController = [self viewControllerForIndex:index];
    self.activeViewControllerIndex = index;
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index fromIndex:(NSUInteger)previousIndex{
    
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index fromIndex:(NSUInteger)previousIndex didSwipe:(BOOL)didSwipe{
    
}

- (void)selectTabAtIndex:(NSUInteger)index didSwipe:(BOOL)didSwipe{
    
}

#pragma mark - Communicator
-(void)loadMenuCategoryList{
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    NSString * store_id = [appConfig getStoreId];
    MenuCommunicator *request = [MenuCommunicator new];
    Bundle *params = [Bundle new];
    [params put:KeyAPI_APP_ID value:APP_ID];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    [params put:KeyAPI_TIME value:currentTime];
    NSArray *strings = [NSArray arrayWithObjects:APP_ID,currentTime,store_id,APP_SECRET,nil];
    [params put:KeyAPI_SIG value:[Utils getSigWithStrings:strings]];
    [params put:KeyAPI_STORE_ID value:store_id];
    [request execute:params withDelegate:self];
    
}

#pragma mark - TenpossCommunicatorDelegate

- (void)completed:(TenpossCommunicator *)request data:(Bundle *)responseParams{
    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
    NSError *error = nil;
    if (errorCode != ERROR_OK) {
        NSString *errorDomain = [CommunicatorConst getErrorMessage:errorCode];
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
    }else{
        MenuResponse *data = (MenuResponse *)[responseParams get:KeyResponseObject];
        if (data.items && [data.items count] > 0) {
            for (MenuCategoryModel *menu in data.items) {
                if(!_menuCategories){
                    _menuCategories = [NSMutableArray new];
                }
                [_menuCategories addObject:menu];
            }
        }else{
            error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_DATASOURCE_NO_CONTENT] code:ERROR_DATASOURCE_NO_CONTENT userInfo:nil];
        }
    }
    if (self.menuCategoryCompleteHandler) {
        self.menuCategoryCompleteHandler(error);
        self.menuCategoryCompleteHandler = nil;
    }
}

@end
