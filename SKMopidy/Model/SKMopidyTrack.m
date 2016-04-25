//
//  SKMopidyTrack.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/24.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyTrack.h"

static NSString const * kKeyDuration = @"length";

@implementation SKMopidyTrack

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    
    _duration = [[dictionary objectForKey:kKeyDuration] unsignedIntegerValue];
    
    return self;
}

@end
