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

@interface SKMopidyPlayer ()

@property(nonatomic, strong, readonly, nonnull) SKMopidyConnection *connection;
@property(nonatomic, strong, readonly, nullable) id source;
@property(nonatomic, strong, readonly, nullable) SKMopidyTlTrack *track;

@end

@implementation SKMopidyPlayer

- (nonnull instancetype)initWithConnection:(nonnull SKMopidyConnection *)connection {
    self = [super init];
    
    _connection = connection;
    
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
    return [NSError errorWithDomain:@"not implemented" code:0 userInfo:nil];
}

- (int)getCurrentPosition {
    return -1;
}

- (int)getDuration {
    return -1;
}

@end
