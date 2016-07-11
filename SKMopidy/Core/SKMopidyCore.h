//
//  SKMopidyCore.h
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/25.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SKUtils/SKUtils.h>

@class SKMopidyConnection;
@class SKMopidyTlTrack;

typedef enum : NSUInteger {
    SKMopidyEventUnknown,
    SKMopidyEventPlaylistLoaded,
    SKMopidyEventTracklistChanged,
    SKMopidyEventPlaybackStateChanged,
    SKMopidyEventPlaybackStarted,
    SKMopidyEventPlaybackPaused,
    SKMopidyEventPlaybackEnded,
    SKMopidyEventPlaybackSeeked
} SKMopidyEventType;

typedef enum : NSUInteger {
    SKMopidyPlaybackUnknown,
    SKMopidyPlaybackStopped,
    SKMopidyPlaybackPlaying,
    SKMopidyPlaybackPaused
} SKMopidyPlaybackState;

@interface SKMopidyCore : NSObject

+ (SKMopidyEventType)eventTypeForCode:(nullable NSString *)code;
+ (SKMopidyPlaybackState)playbackStateForCode:(nullable NSString *)code;

@end
