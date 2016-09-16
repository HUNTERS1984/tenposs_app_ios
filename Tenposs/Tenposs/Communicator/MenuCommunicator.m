//
//  MenuCommunicator.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "MenuCommunicator.h"

@implementation MenuResponse

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data.menus":@"items"}];
}

@end

@implementation MenuCategoryModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"menu_id"}];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.items = (NSMutableArray<ProductObject> *)[[NSMutableArray alloc] init];
        self.pageIndex = 1;
    }
    return self;
}

- (void)addProduct:(ProductObject *)product{
    if (!self.items) {
        self.items = (NSMutableArray<ProductObject> *)[[NSMutableArray alloc] init];
    }
    for (ProductObject *item in self.items) {
        if (item.product_id == product.product_id) {
            [item updateItemWithItem:product];
            return;
        }
    }
    [self.items addObject:product];
}

- (void)increasePageIndex:(NSInteger)count{
    self.pageIndex += count;
}

- (void)removeAllProduct{
    [self.items removeAllObjects];
}

@end

@implementation MenuCommunicator

- (void)customPrepare:(Bundle *)params{
    NSString* strUrl = [NSString stringWithFormat:@"%@%@",[RequestBuilder APIAddress],API_MENU];
    strUrl = [strUrl stringByAppendingFormat:@"%@", [RequestBuilder requestBuilder:params]];
    [params put:KeyRequestURL value:strUrl];
}

- (void)customProcess:(Bundle *)params{
    NSError* error = nil;
    MenuResponse* data = nil;
    @try {
        data = [[MenuResponse alloc] initWithData:self.responseData error:&error];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        
    }
    if( error != nil){
        NSLog(@"%@", error);
        //TODO: real error code
        [params put:KeyResponseResult value:@(9000)];
    }else{
        if(data.code != ERROR_OK){
            NSString* description = [CommunicatorConst getErrorMessage:data.code];
            [params put:KeyResponseResult value:@(data.code)];
            [m_pParams put:KeyResponseError value:description];
            NSLog(@"%@ - err: %ld", [params get:KeyRequestURL], (long)data.code);
        }else{
            [params put:KeyResponseResult value:@(data.code)];
            [params put:KeyResponseObject value:data];
        }
    }
}

@end
