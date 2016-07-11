//
//  SKMopidyConnection+Api.h
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/7/11.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <SKMopidy/SKMopidy.h>

@class SKMopidyTrack;

typedef void (^SKPlaybackStateCallback)(SKMopidyPlaybackState playbackState);
typedef void (^SKMopidyTrackCallback)(SKMopidyTrack * _Nullable track);
typedef void (^SKMopidyTlTrackCallback)(SKMopidyTlTrack * _Nullable tltrack);

@interface SKMopidyConnection (Api)

#pragma mark - Tracklist

- (nullable NSArray *)getTracklist:(NSError * _Nullable *  _Nullable)errorPtr;
- (void)getTracklist:(nonnull SKListCallback)success failure:(nullable SKErrorCallback)failure;

- (void)addTrack:(nonnull NSString *)uri success:(nonnull SKMopidyTlTrackCallback)success failure:(nullable SKErrorCallback)failure;

#pragma mark - Playback

- (SKMopidyPlaybackState)getPlaybackState:(NSError * _Nullable *  _Nullable)errorPtr;
- (void)getPlaybackState:(nonnull SKPlaybackStateCallback)success failure:(nullable SKErrorCallback)failure;

- (nullable SKMopidyTlTrack *)getPlayback:(NSError * _Nullable *  _Nullable)errorPtr;
- (void)getPlayback:(nonnull SKMopidyTlTrackCallback)success failure:(nullable SKErrorCallback)failure;

#pragma mark - Library

- (nullable SKMopidyTrack *)lookup:(nonnull NSString *)uri error:(NSError * _Nullable *  _Nullable)errorPtr;
- (void)lookup:(nonnull NSString *)uri success:(nonnull SKMopidyTrackCallback)success failure:(nullable SKErrorCallback)failure;

@end
