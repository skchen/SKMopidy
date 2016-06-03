//
//  SKMopidyPlayer.h
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

@import SKUtils;

#import "SKMopidyRef.h"
#import "SKMopidyConnection.h"

@interface SKMopidyPlayer : SKPlayer

- (nonnull instancetype)initWithConnection:(nonnull SKMopidyConnection *)connection;

@end
