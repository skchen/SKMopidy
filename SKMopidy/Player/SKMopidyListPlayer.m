//
//  SKMopidyListPlayer.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/6/22.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyListPlayer.h"

#import "SKMopidyPlayer.h"
#import "SKMopidyConnection+Api.h"

#undef SKLog
#define SKLog(__FORMAT__, ...)

@interface SKMopidyListPlayer () <SKPlayerDelegate, SKMopidyConnectionDelegate, SKMopidyPlayerDelegate>

@end

@implementation SKMopidyListPlayer

- (nonnull instancetype)initWithConnection:(nonnull SKMopidyConnection *)connection {
    SKMopidyPlayer *innerPlayer = [[SKMopidyPlayer alloc] initWithConnection:connection];
    innerPlayer.delegate = self;
    innerPlayer.mopidyDelegate = self;
    
    self = [super initWithPlayer:innerPlayer];
    
    _connection = connection;
    _connection.delegate = self;
    
    if([_connection isConnected]) {
        [self mopidyDidConnected:_connection];
    }
    
    return self;
}

#pragma mark - Property

- (id)current {
    return _innerPlayer.current;
}

#pragma mark - Protected

- (void)addDataSource:(id)source atIndex:(NSUInteger)index {
    __weak __typeof__(self) weakSelf = self;
    __weak __typeof__(_source) weakSource = _source;
    
    if([source isKindOfClass:[NSString class]]) {
        [_connection addTrack:source success:^(SKMopidyTlTrack * _Nullable tltrack) {
            [weakSource addObject:tltrack];
        } failure:^(NSError * _Nullable error) {
            [weakSelf notifyError:error callback:nil];
        }];
    } else {
        [self notifyErrorMessage:@"source not supported" callback:nil];
    }
}

#pragma mark - Operations

- (void)updatePlaylist:(nullable SKErrorCallback)callback {
    [_connection getTracklist:^(NSArray * _Nullable list) {
        _source = list;
        id current = [self current];
        
        if(_source && current) {
            _index = [_source indexOfObject:current];
        } else {
            _index = NSNotFound;
        }
        
        if(callback) {
            callback(nil);
        }
    } failure:callback];
}

#pragma mark - SKPlayerDelegate

- (void)player:(SKPlayer *)player didChangeState:(SKPlayerState)newState {
    if([_delegate respondsToSelector:@selector(player:didChangeState:)]) {
        [_delegate player:self didChangeState:newState];
    }
}

#pragma mark - SKMopidyPlayerDelegate

- (void)mopidyPlayerDidConnected:(SKPlayer *)player {
    [self updatePlaylist:^(NSError * _Nullable error) {
        if(error) {
            [self notifyError:error callback:nil];
        } else {
            if([_mopidyDelegate respondsToSelector:@selector(mopidyPlayerDidConnected:)]) {
                [_mopidyDelegate mopidyPlayerDidConnected:self];
            }
        }
    }];
}

#pragma mark - SKMopidyConnectionDelegate

- (void)mopidyDidConnected:(SKMopidyConnection *)connection {
    id<SKMopidyConnectionDelegate> player = (id<SKMopidyConnectionDelegate>)_innerPlayer;
    [player mopidyDidConnected:connection];
}

- (void)mopidy:(SKMopidyConnection *)connection didReceiveEvent:(SKMopidyEvent *)event {
    switch (event.type) {
        case SKMopidyEventTracklistChanged:
            [self updatePlaylist:nil];
            break;
            
        default: {
            id<SKMopidyConnectionDelegate> player = (id<SKMopidyConnectionDelegate>)_innerPlayer;
            [player mopidy:connection didReceiveEvent:event];
        }
            break;
    }
}

@end
