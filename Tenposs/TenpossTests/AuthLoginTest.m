//
//  AuthLoginTest.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 12/4/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AuthenticationManager.h"
#import "UserData.h"


NSString *const T_USERNAME = @"quanlh218@gmail.com";
NSString *const T_PASSWORD = @"123456";
NSString *const T_ROLE = @"client";

@interface AuthLoginTest : XCTestCase

@property (strong, nonatomic) XCTestExpectation *expectation;

@end

@implementation AuthLoginTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExistedUser {
    [self doLogin];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)doLogin{
    self.expectation = [self expectationWithDescription:@"testAnonymousSignIn"];
    [[AuthenticationManager sharedInstance] AuthLoginWithEmail:T_USERNAME password:T_PASSWORD role:T_ROLE andCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
        if(isSuccess){
            //Success
            
            XCTAssertNotNil([resultData objectForKey:@"token"], @"Token cannot be nil at this stage!!");
            XCTAssertNotNil([resultData objectForKey:@"refresh_token"],@"refresh_token cannot be nil at this stage!!");
            XCTAssertNotNil([resultData objectForKey:@"access_refresh_token_href"],@"access_refresh_token_href cannot be nil at this stage!!");
            
            if([[UserData shareInstance] saveTokenKit:resultData]){
                [self doGetUserProflie];
            }else{
                XCTAssertTrue(NO,@"Cannot save token returned by server!!!");
            }
        }else{
            //Success
            XCTAssertFalse([(NSString *)[resultData objectForKey:@"code"] integerValue] == 1000, @"code cannot be 1000 at this stage");
        }
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"TestAuthLogin Timeout Error: %@", error);
        }
    }];
}


- (void)doGetUserProflie{
    [[AuthenticationManager sharedInstance] AuthGetUserProfileWithCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
        if(isSuccess){
            XCTAssertNotNil(resultData,@"No userData while return code is 1000");
            NSLog(@"TEST - UserData: %@", resultData);
        }else{
            
        }
        if(self.expectation != nil){
            [self.expectation fulfill];
            self.expectation = nil;
        }
    }];
}

@end
