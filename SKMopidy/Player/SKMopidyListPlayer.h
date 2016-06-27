//
//  SKMopidyListPlayer.h
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/6/22.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <SKUtils/SKUtils.h>

@class SKMopidyConnection;

@interface SKMopidyListPlayer : SKListPlayer

- (nonnull instancetype)initWithConnection:(nonnull SKMopidyConnection *)connection;

@end
