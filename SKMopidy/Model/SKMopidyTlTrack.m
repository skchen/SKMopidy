//
//  SKMopidyTlTrack.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/24.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyTlTrack.h"

static NSString const * kKeyTrackListId = @"tlid";
static NSString const * kKeyTrack = @"track";

@implementation SKMopidyTlTrack

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary {
    NSDictionary *trackDictionary = [dictionary objectForKey:kKeyTrack];
    
    self = [super initWithDictionary:trackDictionary];
    
    _id = [[dictionary objectForKey:kKeyTrackListId] unsignedIntegerValue];
    
    return self;
}

@end
