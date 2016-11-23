//
//  AuthenticationManager.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/22/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "AuthenticationManager.h"

@implementation AuthenticationManager

+(AuthenticationManager *)sharedInstance{
    
    static AuthenticationManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[AuthenticationManager alloc] init];
    });
    return _sharedInstance;
}




@end
