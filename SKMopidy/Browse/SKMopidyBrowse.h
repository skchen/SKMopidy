//
//  SKMopidyBrowse.h
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKMopidyConnection.h"
#import "SKMopidyRef.h"

@interface SKMopidyBrowse : NSObject

- (nonnull instancetype)initWithConnection:(nonnull SKMopidyConnection *)connection;

- (nullable NSArray<SKMopidyRef *> *)browse:(nullable SKMopidyRef *)parent;

@end
