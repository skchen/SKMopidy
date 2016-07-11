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

- (nullable NSArray *)getTracklist:(NSError * _Nullable *  _Nullable)errorPtr {
    return [self get:kApiTracklistGet parameters:nil error:errorPtr];
}

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

- (SKMopidyPlaybackState)getPlaybackState:(NSError * _Nullable *  _Nullable)errorPtr {
    id result = [self get:kApiPlaybackStateGet parameters:nil error:errorPtr];
    
    if(!(*errorPtr)) {
        return [SKMopidyCore playbackStateForCode:result];
    }
    
    return SKMopidyPlaybackUnknown;
}

- (void)getPlaybackState:(nonnull SKPlaybackStateCallback)success failure:(nullable SKErrorCallback)failure {
    [self get:kApiPlaybackStateGet parameters:nil success:^(id  _Nonnull object) {
        success([SKMopidyCore playbackStateForCode:object]);
    } failure:failure];
}

- (nullable SKMopidyTlTrack *)getPlayback:(NSError * _Nullable *  _Nullable)errorPtr {
    return [self get:kApiPlaybackGet parameters:nil error:errorPtr];
}

- (void)getPlayback:(nonnull SKMopidyTlTrackCallback)success failure:(nullable SKErrorCallback)failure {
    [self get:kApiPlaybackGet parameters:nil success:success failure:failure];
}

#pragma mark - Library

- (nullable SKMopidyTrack *)lookup:(nonnull NSString *)uri error:(NSError * _Nullable *  _Nullable)errorPtr {
    NSDictionary *parameters = @{
                                 kApiParameterUri : uri
                                 };
    
    NSArray *tracks = [self get:kApiLibraryLookup parameters:parameters error:errorPtr];
    
    if([tracks count]>0) {
        return [tracks objectAtIndex:0];
    } else {
        *errorPtr = [NSError errorWithDomain:@"unable to lookup resource" code:0 userInfo:nil];
        return nil;
    }
}

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
