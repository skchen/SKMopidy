//
//  SKMopidyNode.h
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SKMopidyNodeDelegate;

@interface SKMopidyNode : NSObject

- (nonnull instancetype)initWithIp:(nonnull NSString *)ip andPort:(int)port;

@property(nonatomic, weak, nullable) id<SKMopidyNodeDelegate> delegate;

- (void)connect;
- (int)perform:(NSString *)method withParameters:(NSDictionary *)parameters;

@end

@protocol SKMopidyNodeDelegate <NSObject>

- (void)mopidyDidConnected:(nonnull SKMopidyNode *)node;
- (void)mopidy:(SKMopidyNode *)node didGetResult:(NSDictionary *)result forOperation:(int)operationId;

@end
