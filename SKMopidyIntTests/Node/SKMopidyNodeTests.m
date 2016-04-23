//
//  SKMopidyNodeTests.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKMopidyNode.h"

@interface SKMopidyNodeTests : XCTestCase <SKMopidyNodeDelegate>

@end

@implementation SKMopidyNodeTests {
    SKMopidyNode *node;
    
    id<SKMopidyNodeDelegate> mockDelegate;
    
    XCTestExpectation *expectation;
}

- (void)setUp {
    [super setUp];
    
    node = [[SKMopidyNode alloc] initWithIp:@"192.168.2.79" andPort:6680];
    node.delegate = self;
    
    expectation = [self expectationWithDescription:@"setUp"];
    
    [node connect];
    
    [self waitForExpectationsWithTimeout:100 handler:^(NSError * _Nullable error) {
        NSLog(@"setUp Error: %@", error);
    }];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_shouldConnect {
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark - SKMopidyNodeDelegate

- (void)mopidyDidConnected:(SKMopidyNode *)node {
    [expectation fulfill];
}

@end
