//
//  SKMopidyEvent.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/25.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyEvent.h"

static NSString const * kKeyEvent = @"event";

static NSString const *kKeyOldState = @"old_state";
static NSString const *kKeyNewState = @"new_state";

static NSString const *kKeyPosition = @"time_position";
static NSString const *kKeyTlTrack = @"tl_track";

@interface SKMopidyEvent ()

@end

@implementation SKMopidyEvent

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary {
    self = [super init];
    
    _type = [SKMopidyCore eventTypeForCode:[dictionary objectForKey:kKeyEvent]];
    
    _oldState = [SKMopidyCore playbackStateForCode:[dictionary objectForKey:kKeyOldState]];
    _newState = [SKMopidyCore playbackStateForCode:[dictionary objectForKey:kKeyNewState]];
    
    _position = [[dictionary objectForKey:kKeyPosition] unsignedIntegerValue];
    NSDictionary *tltrackDictionary = [dictionary objectForKey:kKeyTlTrack];
    if(tltrackDictionary) {
        _tltrack = [[SKMopidyTlTrack alloc] initWithDictionary:tltrackDictionary];
    }
    
    return self;
}

@end
