//
//  SKMopidyCore.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/25.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyCore.h"

static NSString const * kValueEventPlaylistsLoaded = @"playlists_loaded";
static NSString const * kValueEventTracklistChanged = @"tracklist_changed";
static NSString const * kValueEventPlaybackStateChanged = @"playback_state_changed";
static NSString const * kValueEventPlaybackStarted = @"track_playback_started";
static NSString const * kValueEventPlaybackPaused = @"track_playback_paused";
static NSString const * kValueEventPlaybackEnded = @"track_playback_ended";
static NSString const * kValueEventPlaybackSeeked = @"seeked";

static NSString const * kValuePlaybackStopped = @"stopped";
static NSString const * kValuePlaybackPlaying = @"playing";
static NSString const * kValuePlaybackPaused = @"paused";

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

@end
