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

typedef void (^SKPlaybackStateCallback)(SKMopidyPlaybackState playbackState);
typedef void (^SKPlaybackCallback)(SKMopidyTlTrack * _Nullable playback);

@interface SKMopidyCore : NSObject

+ (SKMopidyEventType)eventTypeForCode:(nullable NSString *)code;
+ (SKMopidyPlaybackState)playbackStateForCode:(nullable NSString *)code;

+ (SKMopidyPlaybackState)getPlaybackState:(nonnull SKMopidyConnection *)connection error:(NSError * _Nullable *  _Nullable)errorPtr;
+ (void)getPlaybackState:(nonnull SKMopidyConnection *)connection success:(nonnull SKPlaybackStateCallback)success failure:(nullable SKErrorCallback)failure;

+ (nullable SKMopidyTlTrack *)getPlayback:(nonnull SKMopidyConnection *)connection error:(NSError * _Nullable *  _Nullable)errorPtr;
+ (void)getPlayback:(nonnull SKMopidyConnection *)connection success:(nonnull SKPlaybackCallback)success failure:(nullable SKErrorCallback)failure;

+ (nullable NSArray *)getPlaybackList:(nonnull SKMopidyConnection *)connection error:(NSError * _Nullable *  _Nullable)errorPtr;
+ (void)getPlaybackList:(nonnull SKMopidyConnection *)connection success:(nonnull SKListCallback)success failure:(nullable SKErrorCallback)failure;

@end
