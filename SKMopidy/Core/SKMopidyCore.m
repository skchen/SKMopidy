//
//  SKMopidyCore.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/25.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyCore.h"

#import "SKMopidyConnection.h"

static NSString * const kValueEventPlaylistsLoaded = @"playlists_loaded";
static NSString * const kValueEventTracklistChanged = @"tracklist_changed";
static NSString * const kValueEventPlaybackStateChanged = @"playback_state_changed";
static NSString * const kValueEventPlaybackStarted = @"track_playback_started";
static NSString * const kValueEventPlaybackPaused = @"track_playback_paused";
static NSString * const kValueEventPlaybackEnded = @"track_playback_ended";
static NSString * const kValueEventPlaybackSeeked = @"seeked";

static NSString * const kValuePlaybackStopped = @"stopped";
static NSString * const kValuePlaybackPlaying = @"playing";
static NSString * const kValuePlaybackPaused = @"paused";

static NSString * const kApiPlaybackStateGet = @"core.playback.get_state";
static NSString * const kApiPlaybackGet = @"core.playback.get_current_tl_track";

static NSString * const kApiTracklistGet = @"core.tracklist.get_tl_tracks";

@implementation SKMopidyCore

+ (SKMopidyEventType)eventTypeForCode:(nullable NSString *)code {
    NSArray *candidates = @[@"",
                            kValueEventPlaylistsLoaded,
                            kValueEventTracklistChanged,
                            kValueEventPlaybackStateChanged,
                            kValueEventPlaybackStarted,
                            kValueEventPlaybackPaused,
                            kValueEventPlaybackEnded,
                            kValueEventPlaybackSeeked];
    return [SKMopidyCore enumForCode:code inCandidates:candidates];
}

+ (SKMopidyPlaybackState)playbackStateForCode:(nullable NSString *)code {
    NSArray *candidates = @[@"", kValuePlaybackStopped, kValuePlaybackPlaying, kValuePlaybackPaused];
    return [SKMopidyCore enumForCode:code inCandidates:candidates];
}

+ (NSUInteger)enumForCode:(nullable NSString *)code inCandidates:(nonnull NSArray *)candidates {
    if(code) {
        NSUInteger index = [candidates indexOfObject:code];
        if(index!=NSNotFound) {
            return index;
        } else {
            NSLog(@"Code \"%@\" not found", code);
        }
    }
    return 0;
}

+ (nullable id)get:(nonnull NSString *)command connection:(nonnull SKMopidyConnection *)connection error:(NSError * _Nullable *  _Nullable)errorPtr {
    SKMopidyRequest *request = [connection perform:command];
    if(request.error) {
        *errorPtr = request.error;
    } else {
        return request.result;
    }
    
    return nil;
}

+ (void)get:(nonnull NSString *)command connection:(nonnull SKMopidyConnection *)connection success:(nonnull SKObjectCallback)success failure:(nullable SKErrorCallback)failure {
    [connection perform:command success:^(id  _Nonnull object) {
        success(object);
    } failure:failure];
}

+ (SKMopidyPlaybackState)getPlaybackState:(nonnull SKMopidyConnection *)connection error:(NSError * _Nullable *  _Nullable)errorPtr {
    id result = [SKMopidyCore get:kApiPlaybackStateGet connection:connection error:errorPtr];
    
    if(!(*errorPtr)) {
        return [self playbackStateForCode:result];
    }
    
    return SKMopidyPlaybackUnknown;
}

+ (void)getPlaybackState:(nonnull SKMopidyConnection *)connection success:(nonnull SKPlaybackStateCallback)success failure:(nullable SKErrorCallback)failure {
    
    [SKMopidyCore get:kApiPlaybackStateGet connection:connection success:^(id  _Nonnull object) {
        success([self playbackStateForCode:object]);
    } failure:failure];
}

+ (nullable SKMopidyTlTrack *)getPlayback:(nonnull SKMopidyConnection *)connection error:(NSError * _Nullable *  _Nullable)errorPtr {
    return [SKMopidyCore get:kApiPlaybackGet connection:connection error:errorPtr];
}

+ (void)getPlayback:(nonnull SKMopidyConnection *)connection success:(nonnull SKPlaybackCallback)success failure:(nullable SKErrorCallback)failure {
    [SKMopidyCore get:kApiPlaybackGet connection:connection success:success failure:failure];
}

+ (nullable NSArray *)getPlaybackList:(nonnull SKMopidyConnection *)connection error:(NSError * _Nullable *  _Nullable)errorPtr {
    return [SKMopidyCore get:kApiTracklistGet connection:connection error:errorPtr];
}

+ (void)getPlaybackList:(nonnull SKMopidyConnection *)connection success:(nonnull SKListCallback)success failure:(nullable SKErrorCallback)failure {
    [SKMopidyCore get:kApiTracklistGet connection:connection success:success failure:failure];
}

@end
