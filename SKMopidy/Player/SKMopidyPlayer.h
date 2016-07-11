//
//  SKMopidyPlayer.h
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <SKUtils/SKUtils.h>

#import "SKMopidyCore.h"

@class SKMopidyConnection;

@protocol SKMopidyPlayerDelegate <NSObject>

@optional
- (void)mopidyPlayerDidConnected:(nonnull SKPlayer *)player;
- (void)mopidyPlayerDidDisconnected:(nonnull SKPlayer *)player;

@end

@interface SKMopidyPlayer : SKPlayer

@property(nonatomic, weak, nullable) id<SKMopidyPlayerDelegate> mopidyDelegate;

@property(nonatomic, strong, readonly, nonnull) SKMopidyConnection *connection;

+ (SKPlayerState)playerStateForMopidyPlaybackState:(SKMopidyPlaybackState)mopidyPlaybackState;

- (nonnull instancetype)initWithConnection:(nonnull SKMopidyConnection *)connection;



@end
