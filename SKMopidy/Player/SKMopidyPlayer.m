//
//  SKMopidyPlayer.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyPlayer.h"

#import "SKMopidyConnection+Api.h"
#import "SKMopidyCore.h"
#import "SKMopidyTlTrack.h"

#undef SKLog
#define SKLog(__FORMAT__, ...)

@interface SKMopidyPlayer () <SKMopidyConnectionDelegate>

@property(nonatomic, strong, readonly, nullable) SKMopidyTlTrack *track;

@property(nonatomic, copy, nullable) SKErrorCallback startCallback;

@end

@implementation SKMopidyPlayer

+ (SKPlayerState)playerStateForMopidyPlaybackState:(SKMopidyPlaybackState)mopidyPlaybackState {
    switch(mopidyPlaybackState) {
        case SKMopidyPlaybackStopped:
            return SKPlayerPrepared;
            
        case SKMopidyPlaybackPlaying:
            return SKPlayerStarted;
            
        case SKMopidyPlaybackPaused:
            return SKPlayerPaused;
            
        default:
            return SKPlayerStopped;
    }
}

- (nonnull instancetype)initWithConnection:(nonnull SKMopidyConnection *)connection {
    self = [super init];
    
    _connection = connection;
    _connection.delegate = self;
    
    if([_connection isConnected]) {
        [self mopidyDidConnected:_connection];
    }
    
    return self;
}

#pragma mark - Abstract

- (void)_setDataSource:(id)source {
    // Do Nothing
}

- (void)_prepare:(SKErrorCallback)callback {
    SKMopidyRequest *trackListClearRequest = [_connection perform:@"core.tracklist.clear"];
    if(trackListClearRequest.error) {
        callback(trackListClearRequest.error);
        return;
    }
    
    SKMopidyRequest *uriAddRequest = [_connection perform:@"core.tracklist.add" withParameters:@{@"uri":_source}];
    if(uriAddRequest.error) {
        callback(uriAddRequest.error);
        return;
    }
    
    NSArray *trackList = uriAddRequest.result;
    if(trackList) {
        if([trackList count]>0) {
            _track = [trackList objectAtIndex:0];
            callback(nil);
            return;
        }
    }
    
    callback([NSError errorWithDomain:@"Unknown error" code:0 userInfo:nil]);
}

- (void)_start:(SKErrorCallback)callback {
    _startCallback = callback;
    
    SKMopidyRequest *playRequest = [_connection perform:@"core.playback.play"];
    if(playRequest.error) {
        if(_startCallback) {
            _startCallback(playRequest.error);
            _startCallback = nil;
        }
    }
}

- (void)_pause:(SKErrorCallback)callback {
    SKMopidyRequest *pauseRequest = [_connection perform:@"core.playback.pause"];
    if(pauseRequest.error) {
        callback(pauseRequest.error);
        return;
    }
    
    callback(nil);
}

- (void)_stop:(SKErrorCallback)callback {
    SKMopidyRequest *stopRequest = [_connection perform:@"core.playback.stop"];
    if(stopRequest.error) {
        callback(stopRequest.error);
        return;
    }
    
    callback(nil);
}

- (void)seekTo:(NSTimeInterval)time success:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    switch(_state) {
        case SKPlayerPrepared:{
            [self start:^(NSError * _Nullable error) {
                if(error) {
                    if(failure) {
                        dispatch_async(self.callbackQueue, ^{
                            failure(error);
                        });
                    }
                } else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self seekTo:time success:success failure:failure];
                    });
                }
            }];
        }
            break;
            
        default:
            [super seekTo:time success:success failure:failure];
            break;
    }
}

- (void)_seekTo:(NSTimeInterval)time success:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    
    int msec = (int)round(time*1000);
    
    SKMopidyRequest *seekRequest = [_connection perform:@"core.playback.seek" withParameters:@{@"time_position":@(msec)}];
    if(seekRequest.error) {
        failure(seekRequest.error);
        return;
    }
    
    if(seekRequest.result) {
        success(time);
        return;
    }
    
    failure([NSError errorWithDomain:@"Unknown error" code:0 userInfo:nil]);
}

- (void)_getCurrentPosition:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    SKMopidyRequest *positionRequest = [_connection perform:@"core.playback.get_time_position"];
    if(positionRequest.result) {
        int msec = [positionRequest.result intValue];
        NSTimeInterval currentPosition = (float)msec / 1000;
        success(currentPosition);
    } else {
        failure(positionRequest.error);
    }
}

- (void)getDuration:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    NSUInteger msec = _track.duration;
    NSTimeInterval duration = (float)msec / 1000;
    success(duration);
}

#pragma mark - SKMopidyConnectionDelegate

- (void)mopidyDidConnected:(SKMopidyConnection *)connection {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SKErrorCallback onError = ^(NSError * _Nullable error) {
            [self notifyError:error callback:nil];
        };
        
        [connection getPlayback:^(SKMopidyTlTrack * _Nullable playback) {
            _source = playback;
            
            [connection getPlaybackState:^(SKMopidyPlaybackState playbackState) {
                _state = [SKMopidyPlayer playerStateForMopidyPlaybackState:playbackState];
                
                if([_mopidyDelegate respondsToSelector:@selector(mopidyPlayerDidConnected:)]) {
                    [_mopidyDelegate mopidyPlayerDidConnected:self];
                }
            } failure:onError];
        } failure:onError];
    });
}

- (void)mopidy:(SKMopidyConnection *)connection didReceiveEvent:(SKMopidyEvent *)event {
    
    SKLog(@"%@", event);
    
    switch(event.type) {
        case SKMopidyEventPlaybackStarted:
            _source = event.tltrack;
            
            if(_startCallback) {
                _startCallback(nil);
                _startCallback = nil;
            }
            break;
            
        case SKMopidyEventPlaybackEnded:
            break;
            
        default:
            break;
    }
}

@end
