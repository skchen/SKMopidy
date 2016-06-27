//
//  SKMopidyPlayer.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyPlayer.h"

#import "SKMopidyConnection.h"
#import "SKMopidyTlTrack.h"

@interface SKMopidyPlayer () <SKMopidyConnectionDelegate>

@property(nonatomic, strong, readonly, nonnull) SKMopidyConnection *connection;
@property(nonatomic, strong, readonly, nullable) SKMopidyTlTrack *track;

@end

@implementation SKMopidyPlayer

- (nonnull instancetype)initWithConnection:(nonnull SKMopidyConnection *)connection {
    self = [super init];
    
    _connection = connection;
    _connection.delegate = self;
    
    return self;
}

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
    SKMopidyRequest *playRequest = [_connection perform:@"core.playback.play"];
    if(playRequest.error) {
        callback(playRequest.error);
        return;
    }
    
    callback(nil);
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

- (void)mopidy:(SKMopidyConnection *)connection didReceiveEvent:(SKMopidyEvent *)event {
    switch(event.type) {
        case SKMopidyEventPlaybackEnded:
            [self notifyCompletion:nil];
            break;
            
        default:
            break;
    }
}

@end
