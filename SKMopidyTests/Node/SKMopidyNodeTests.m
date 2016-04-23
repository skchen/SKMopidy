//
//  SKMopidyNodeTests.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKMopidyNode.h"

@import OCMockito;

@interface SKMopidyNodeTests : XCTestCase

@end

@implementation SKMopidyNodeTests {
    SKMopidyNode *node;
    
    id<SKMopidyNodeDelegate> mockDelegate;
}

- (void)setUp {
    [super setUp];
    
    mockDelegate = mockProtocol(@protocol(SKMopidyNodeDelegate));
    
    node = [[SKMopidyNode alloc] initWithIp:@"192.168.2.79" andPort:6680];
    node.delegate = mockDelegate;
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_shouldConnect {
    [node connect];
    
    [verify(mockDelegate) mopidyDidConnected:node];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
