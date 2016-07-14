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

@property(nonatomic, strong, readonly, nonnull) SKPlayer *innerPlayer;

@end

@implementation SKMopidyListPlayer

- (nonnull instancetype)initWithConnection:(nonnull SKMopidyConnection *)connection {
    
    SKMopidyPlayer *innerPlayer = [[SKMopidyPlayer alloc] initWithConnection:connection];
    innerPlayer.delegate = self;
    innerPlayer.mopidyDelegate = self;
    
    _innerPlayer = innerPlayer;
    _innerPlayer.delegate = self;
    
    _connection = connection;
    _connection.delegate = self;
    
    if([_connection isConnected]) {
        [self mopidyDidConnected:_connection];
    }
    
    return self;
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
        
        id current = [list objectAtIndex:_index];
        
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

- (void)playerDidChangeState:(SKPlayer *)player {
    if([_delegate respondsToSelector:@selector(playerDidChangeState:)]) {
        [self playerDidChangeState:self];
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
