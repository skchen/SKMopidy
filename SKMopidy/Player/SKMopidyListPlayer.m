//
//  SKMopidyListPlayer.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/6/22.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyListPlayer.h"

#import "SKMopidyPlayer.h"
#import "SKMopidyConnection.h"

@interface SKMopidyListPlayer () <SKMopidyConnectionDelegate>

@property(nonatomic, strong, readonly, nonnull) SKMopidyConnection *connection;

@end

@implementation SKMopidyListPlayer

- (nonnull instancetype)initWithConnection:(nonnull SKMopidyConnection *)connection {
    SKMopidyPlayer *innerPlayer = [[SKMopidyPlayer alloc] initWithConnection:connection];
    
    self = [super initWithPlayer:innerPlayer];
    
    _connection = connection;
    _connection.delegate = self;
    
    if([_connection isConnected]) {
        [self mopidyDidConnected:_connection];
    }
    
    return self;
}

#pragma mark - SKMopidyConnectionDelegate

- (void)mopidyDidConnected:(SKMopidyConnection *)connection {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SKErrorCallback onError = ^(NSError * _Nullable error) {
            NSLog(@"Error: %@", error);
            [self changeState:SKPlayerStopped callback:nil];
        };
        
        [SKMopidyCore getPlayback:connection success:^(SKMopidyTlTrack * _Nullable playback) {
            [SKMopidyCore getPlaybackList:connection success:^(NSArray * _Nullable list) {
                _source = list;
                
                if(playback) {
                    _index = NSNotFound;
                } else {
                    _index = [list indexOfObject:playback];
                }
                
                [SKMopidyCore getPlaybackState:_connection success:^(SKMopidyPlaybackState playbackState) {
                    SKPlayerState state = [SKMopidyPlayer playerStateForMopidyPlaybackState:playbackState];
                    [self changeState:state callback:nil];
                } failure:onError];
            } failure:onError];
        } failure:onError];
    });
}

@end
