//
//  SKMopidyEvent.h
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/25.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKMopidyCore.h"
#import "SKMopidyTlTrack.h"

@interface SKMopidyEvent : NSObject

@property(nonatomic, readonly) SKMopidyEventType type;

@property(nonatomic, readonly) SKMopidyPlaybackState oldState;
@property(nonatomic, readonly) SKMopidyPlaybackState newState;

@property(nonatomic, readonly) NSUInteger position;
@property(nonatomic, strong, readonly, nullable) SKMopidyTlTrack *tltrack;

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;

@end
