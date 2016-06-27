//
//  SKMopidyPlayer.h
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <SKUtils/SKUtils.h>

@class SKMopidyConnection;

@interface SKMopidyPlayer : SKPlayer

- (nonnull instancetype)initWithConnection:(nonnull SKMopidyConnection *)connection;

@end
