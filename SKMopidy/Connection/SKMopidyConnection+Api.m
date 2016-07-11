//
//  SKMopidyConnection+Api.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/7/11.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyConnection+Api.h"

static NSString * const kApiParameterUri = @"uri";
static NSString * const kApiParameterTrackList = @"tracks";

static NSString * const kApiPlaybackStateGet = @"core.playback.get_state";
static NSString * const kApiPlaybackGet = @"core.playback.get_current_tl_track";

static NSString * const kApiPlaybackPlay = @"core.playback.play";
static NSString * const kApiPlaybackResume = @"core.playback.resume";
static NSString * const kApiPlaybackPause = @"core.playback.pause";
static NSString * const kApiPlaybackStop = @"core.playback.stop";

static NSString * const kApiTracklistGet = @"core.tracklist.get_tl_tracks";
static NSString * const kApiTracklistAdd = @"core.tracklist.add";

static NSString * const kApiLibraryLookup = @"core.library.lookup";

@implementation SKMopidyConnection (Api)

#pragma mark - Basic

- (nullable id)get:(nonnull NSString *)command parameters:(nullable NSDictionary *)parameters error:(NSError * _Nullable *  _Nullable)errorPtr {
    SKMopidyRequest *request = [self perform:command withParameters:parameters];
    if(request.error) {
        *errorPtr = request.error;
    } else {
        return request.result;
    }
    
    return nil;
}

- (void)get:(nonnull NSString *)command parameters:(nullable NSDictionary *)parameters success:(nonnull SKObjectCallback)success failure:(nullable SKErrorCallback)failure {
    [self perform:command withParameters:parameters success:^(id  _Nonnull object) {
        success(object);
    } failure:failure];
}

#pragma mark - Tracklist

- (void)getTracklist:(nonnull SKListCallback)success failure:(nullable SKErrorCallback)failure {
    [self get:kApiTracklistGet parameters:nil success:success failure:failure];
}

- (void)addTrack:(nonnull NSString *)uri success:(nonnull SKMopidyTlTrackCallback)success failure:(nullable SKErrorCallback)failure {
    NSDictionary *parameters = @{
                                 kApiParameterUri : uri
                                 };
    
    [self get:kApiTracklistAdd parameters:parameters success:^(id  _Nullable object) {
        NSArray *addedTracks = (NSArray *)object;
        if([addedTracks count]>0) {
            success([addedTracks objectAtIndex:0]);
        } else {
            failure([NSError errorWithDomain:@"Unable to add track" code:0 userInfo:nil]);
        }
    } failure:failure];
}

#pragma mark - Playback

- (void)getPlaybackState:(nonnull SKPlaybackStateCallback)success failure:(nullable SKErrorCallback)failure {
    [self get:kApiPlaybackStateGet parameters:nil success:^(id  _Nonnull object) {
        success([SKMopidyCore playbackStateForCode:object]);
    } failure:failure];
}

- (void)getPlayback:(nonnull SKMopidyTlTrackCallback)success failure:(nullable SKErrorCallback)failure {
    [self get:kApiPlaybackGet parameters:nil success:success failure:failure];
}

- (void)play:(nullable SKErrorCallback)callback {
    [self get:kApiPlaybackPlay parameters:nil success:^(id  _Nullable object) {
        callback(nil);
    } failure:callback];
}

- (void)resume:(nullable SKErrorCallback)callback {
    [self get:kApiPlaybackResume parameters:nil success:^(id  _Nullable object) {
        callback(nil);
    } failure:callback];
}

- (void)pause:(nullable SKErrorCallback)callback {
    [self get:kApiPlaybackPause parameters:nil success:^(id  _Nullable object) {
        callback(nil);
    } failure:callback];
}

- (void)stop:(nullable SKErrorCallback)callback {
    [self get:kApiPlaybackStop parameters:nil success:^(id  _Nullable object) {
        callback(nil);
    } failure:callback];
}


#pragma mark - Library

- (void)lookup:(nonnull NSString *)uri success:(nonnull SKMopidyTrackCallback)success failure:(nullable SKErrorCallback)failure {
    NSDictionary *parameters = @{
                                 kApiParameterUri : uri
                                 };

    [self get:kApiLibraryLookup parameters:parameters success:^(id  _Nullable object) {
        NSArray *tracks = (NSArray *)object;
        if([tracks count]>0) {
            success([tracks objectAtIndex:0]);
        } else {
            failure([NSError errorWithDomain:@"unable to lookup resource" code:0 userInfo:nil]);
        }
    } failure:failure];
}

@end
