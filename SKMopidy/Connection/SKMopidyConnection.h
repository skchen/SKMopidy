//
//  SKMopidyConnection.h
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKMopidyRequest.h"

@protocol SKMopidyConnectionDelegate;

@interface SKMopidyConnection : NSObject

- (nonnull instancetype)initWithIp:(nonnull NSString *)ip andPort:(int)port;

@property(nonatomic, weak, nullable) id<SKMopidyConnectionDelegate> delegate;

- (void)connect;

- (nonnull SKMopidyRequest *)perform:(nonnull NSString *)method;
- (nonnull SKMopidyRequest *)perform:(nonnull NSString *)method withParameters:(nullable NSDictionary *)parameters;

@end

@protocol SKMopidyConnectionDelegate <NSObject>

- (void)mopidyDidConnected:(nonnull SKMopidyConnection *)connection;

@end
