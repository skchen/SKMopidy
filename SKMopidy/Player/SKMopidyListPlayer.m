//
//  SKMopidyListPlayer.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/6/22.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyListPlayer.h"

#import "SKMopidyConnection.h"

@interface SKMopidyListPlayer () <SKMopidyConnectionDelegate>

@property(nonatomic, strong, readonly, nonnull) SKMopidyConnection *connection;

@end

@implementation SKMopidyListPlayer

- (nonnull instancetype)initWithConnection:(nonnull SKMopidyConnection *)connection {
    self = [super init];
    
    _connection = connection;
    _connection.delegate = self;
    
    return self;
}

@end
