//
//  SKMopidyBrowseTests.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKMopidyBrowse.h"

@interface SKMopidyBrowseTests : XCTestCase <SKMopidyConnectionDelegate>

@end

@implementation SKMopidyBrowseTests {
    SKMopidyConnection *connection;
    SKMopidyBrowse *browser;
    
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
    
    browser = [[SKMopidyBrowse alloc] initWithConnection:connection];}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_shouldGetRoot_whenBrowseWithNilPath {
    NSArray<SKMopidyRef *> *result = [browser browse:nil];
    NSLog(@"result: %@", result);
}

- (void)test_shouldGetRefContent_whenBrowseWithRef {
    NSArray<SKMopidyRef *> *rootDirectories = [browse list:nil];
    SKMopidyRef *targetDirectory = [rootDirectories     objectAtIndex:0];
    NSArray<SKMopidyRef *> *result = [browser browse:targetDirectory];
    NSLog(@"result: %@", result);
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
