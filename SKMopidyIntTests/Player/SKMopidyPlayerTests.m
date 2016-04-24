//
//  SKMopidyPlayerTests.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/24.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKMopidyPlayer.h"

static NSString const * kUriToPlay = @"local:track:MusicBox/%E3%80%90%E7%94%B0%E9%A6%A5%E7%94%84%20Hebe%E3%80%91To%20Hebe/11.%20Love%20%21.mp3";

@interface SKMopidyPlayerTests : XCTestCase <SKMopidyConnectionDelegate>

@end

@implementation SKMopidyPlayerTests {
    SKMopidyConnection *connection;
    SKMopidyPlayer *player;
    
    XCTestExpectation *expectation;
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
    
    player = [[SKMopidyPlayer alloc] initWithConnection:connection];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_setUriAsDataSource {
    NSError *error = [player setDataSource:kUriToPlay];
    XCTAssertNil(error);
}

- (void)test_prepare_whenUriSetAsDataSource {
    [player setDataSource:kUriToPlay];
    NSError *error = [player prepare];
    XCTAssertNil(error);
}

- (void)test_play_whenUriSetAsDataSourceAndPrepared {
    [player setDataSource:kUriToPlay];
    [player prepare];
    NSError *error = [player start];
    XCTAssertNil(error);
}

- (void)test_pause_whenUriSetAsDataSourcePreparedAndStarted {
    [player setDataSource:kUriToPlay];
    [player prepare];
    [player start];
    NSError *error = [player pause];
    XCTAssertNil(error);
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
