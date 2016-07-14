//
//  SKMopidyPlayer.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyPlayer.h"

#import "SKMopidyCore.h"
#import "SKMopidyTlTrack.h"
#import "SKMopidyConnection+Api.h"

#undef SKLog
#define SKLog(__FORMAT__, ...)

@interface SKMopidyPlayer () <SKMopidyConnectionDelegate>

@end

@implementation SKMopidyPlayer

+ (SKPlayerState)playerStateForMopidyPlaybackState:(SKMopidyPlaybackState)mopidyPlaybackState {
    switch(mopidyPlaybackState) {
        case SKMopidyPlaybackStopped:
            return SKPlayerStopped;
            
        case SKMopidyPlaybackPlaying:
            return SKPlayerPlaying;
            
        case SKMopidyPlaybackPaused:
            return SKPlayerPaused;
            
        default:
            return SKPlayerUnknown;
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

- (void)_setSource:(id)source callback:(SKErrorCallback)callback {
    __weak __typeof(self) weakSelf = self;
    
    if([source isKindOfClass:[NSString class]]) {
        [_connection clearTracklist:^(NSError * _Nullable error) {
            if(error) {
                callback(error);
            } else {
                [_connection addTrack:source success:^(SKMopidyTlTrack * _Nullable tltrack) {
                    [weakSelf changeSource:tltrack callback:callback];
                } failure:callback];
            }
        }];
    } else  if([source isKindOfClass:[SKMopidyRef class]]) {
        SKMopidyRef *ref = (SKMopidyRef *)source;
        [self _setSource:ref.uri callback:callback];
    } else {
        [self notifyErrorMessage:@"Unable to set source" callback:callback];
    }
}

- (void)_start:(SKErrorCallback)callback {
    [_connection play:callback];
}

- (void)_resume:(SKErrorCallback)callback {
    [_connection resume:callback];
}

- (void)_pause:(SKErrorCallback)callback {
    [_connection pause:callback];
}

- (void)_stop:(SKErrorCallback)callback {
    [_connection stop:callback];
}

- (void)_getDuration:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    NSUInteger msec = ((SKMopidyTlTrack *)_source).duration;
    NSTimeInterval duration = (float)msec / 1000;
    success(duration);
}

- (void)_getProgress:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    [_connection getTimePosition:success failure:failure];
}

- (void)_seekTo:(NSTimeInterval)time success:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    [_connection seek:time callback:^(NSError * _Nullable error) {
        if(error) {
            failure(error);
        } else {
            success(time);
        }
    }];
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
            [self changeSource:event.tltrack callback:nil];
            [self changeState:SKPlayerPlaying callback:nil];
            break;
            
        case SKMopidyEventPlaybackResumed:
            [self changeState:SKPlayerPlaying callback:nil];
            break;
            
        case SKMopidyEventPlaybackPaused:
            [self changeState:SKPlayerPaused callback:nil];
            break;
            
        case SKMopidyEventPlaybackEnded:
            [self changeState:SKPlayerStopped callback:nil];
            break;
            
        default:
            break;
    }
}

@end
