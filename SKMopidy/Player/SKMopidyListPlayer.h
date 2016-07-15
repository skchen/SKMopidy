//
//  SKMopidyListPlayer.h
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/6/22.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <SKUtils/SKUtils.h>

#import "SKMopidyPlayer.h"

@class SKMopidyConnection;

@interface SKMopidyListPlayer : SKNestedListPlayer

@property(nonatomic, weak, nullable) id<SKMopidyPlayerDelegate> mopidyDelegate;

@property(nonatomic, strong, readonly, nonnull) SKMopidyConnection *connection;

- (nonnull instancetype)initWithConnection:(nonnull SKMopidyConnection *)connection;

@end
