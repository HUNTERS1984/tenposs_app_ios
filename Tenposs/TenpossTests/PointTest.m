//
//  PointTest.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 12/5/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AuthenticationManager.h"
#import "PointManager.h"
#import "UserData.h"

@interface PointTest : XCTestCase
@property (strong, nonatomic) XCTestExpectation *expectation;
@end

@implementation PointTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetUserPoint {
    self.expectation = [self expectationWithDescription:@"testGetUserPoint"];
    [[AuthenticationManager sharedInstance] AuthLoginWithEmail:@"quanlh218@gmail.com" password:@"123456" role:@"client" andCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
        if (isSuccess) {
            [[UserData shareInstance] saveTokenKit:resultData];
            [[PointManager sharedInstance] PointGetUserPointWithCompleteBlock:^(BOOL isSuccess, NSDictionary *resultData) {
                if (isSuccess) {
                    CommonResponse *data = (CommonResponse *)resultData;
                    XCTAssertNotNil(data.data,@"Data cannot be nil!!!");
                    NSLog(@"TEST - Point of user: %@",data.data);
                }else{
                    
                }
                if(self.expectation != nil){
                    [self.expectation fulfill];
                    self.expectation = nil;
                }
            }];
        }else{
            if(self.expectation != nil){
                [self.expectation fulfill];
                self.expectation = nil;
            }
        }
    }];
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"TestAuthLogin Timeout Error: %@", error);
        }
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
