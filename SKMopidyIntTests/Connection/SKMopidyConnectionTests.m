//
//  SKMopidyConnectionTests.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

@import SKMopidy;

@interface SKMopidyConnectionTests : XCTestCase <SKMopidyConnectionDelegate>

@end

@implementation SKMopidyConnectionTests {
    SKMopidyConnection *connection;
    XCTestExpectation *expectation;
    
    int pendingRequestId;
    NSDictionary *pendingRequestResult;
}

- (void)setUp {
    [super setUp];
    
    connection = [[SKMopidyConnection alloc] initWithIp:@"192.168.2.79" andPort:6680];
    connection.delegate = self;
    
    expectation = [self expectationWithDescription:@"setUp"];
    
    [connection connect];
    
    [self waitForExpectationsWithTimeout:100 handler:^(NSError * _Nullable error) {
        NSLog(@"setUp Error: %@", error);
    }];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_shouldGetResult_whenSendMethodWithoutParameter {
    SKMopidyRequest *request = [connection perform:@"core.playback.get_state"];
    NSLog(@"Result: %@", request.result);
}

- (void)test_shouldGetResult_whenSendMethodWithParameter {
    SKMopidyRequest *request = [connection perform:@"core.library.browse" withParameters:@{@"uri" : [NSNull null]}];
    NSLog(@"Result: %@", request.result);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark - SKMopidyConnectionDelegate

- (void)mopidyDidConnected:(SKMopidyConnection *)connection {
    [expectation fulfill];
}

@end
