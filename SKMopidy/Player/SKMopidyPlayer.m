//
//  SKMopidyPlayer.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyPlayer.h"

#import <SKUtils/SKPlayer_Protected.h>

#import "SKMopidyTlTrack.h"

@interface SKMopidyPlayer () <SKMopidyConnectionDelegate>

@property(nonatomic, strong, readonly, nonnull) SKMopidyConnection *connection;
@property(nonatomic, strong, readonly, nullable) id source;
@property(nonatomic, strong, readonly, nullable) SKMopidyTlTrack *track;

@end

@implementation SKMopidyPlayer

- (nonnull instancetype)initWithConnection:(nonnull SKMopidyConnection *)connection {
    self = [super init];
    
    _connection = connection;
    _connection.delegate = self;
    
    return self;
}

- (nullable NSError *)_setDataSource:(nonnull id)source {
    _source = source;
    return nil;
}

- (nullable NSError *)_prepare {
    SKMopidyRequest *trackListClearRequest = [_connection perform:@"core.tracklist.clear"];
    if(trackListClearRequest.error) {
        return trackListClearRequest.error;
    }
    
    SKMopidyRequest *uriAddRequest = [_connection perform:@"core.tracklist.add" withParameters:@{@"uri":_source}];
    
    NSArray *trackList = uriAddRequest.result;
    if(trackList) {
        if([trackList count]>0) {
            _track = [trackList objectAtIndex:0];
            return nil;
        }
    }
    
    NSError *error = uriAddRequest.error;
    if(error) {
        return error;
    } else {
        return [NSError errorWithDomain:@"Unknown error" code:0 userInfo:nil];
    }
}

- (nullable NSError *)_start {
    SKMopidyRequest *playRequest = [_connection perform:@"core.playback.play"];
    if(playRequest.error) {
        return playRequest.error;
    }
    
    return nil;
}

- (nullable NSError *)_pause {
    SKMopidyRequest *pauseRequest = [_connection perform:@"core.playback.pause"];
    if(pauseRequest.error) {
        return pauseRequest.error;
    }
    
    return nil;
}

- (nullable NSError *)_stop {
    SKMopidyRequest *stopRequest = [_connection perform:@"core.playback.stop"];
    if(stopRequest.error) {
        return stopRequest.error;
    }
    
    return nil;
}

- (nullable NSError *)_seekTo:(int)msec {
    SKMopidyRequest *seekRequest = [_connection perform:@"core.playback.seek" withParameters:@{@"time_position":@(msec)}];
    if(seekRequest.error) {
        return seekRequest.error;
    }
    
    if(!seekRequest.result) {
        return [NSError errorWithDomain:@"unable to seek" code:0 userInfo:nil];
    }
    
    return nil;
}

- (int)getCurrentPosition {
    SKMopidyRequest *positionRequest = [_connection perform:@"core.playback.get_time_position"];
    if(positionRequest.result) {
        return [positionRequest.result intValue];
    }
    return -1;
}

- (int)getDuration {
    return _track.duration;
}

#pragma mark - SKMopidyConnectionDelegate

- (void)mopidy:(SKMopidyConnection *)connection didReceiveEvent:(SKMopidyEvent *)event {
    switch(event.type) {
        case SKMopidyEventPlaybackEnded:
            [self notifyCompletion];
            break;
            
        default:
            break;
    }
}

@end
