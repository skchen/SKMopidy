//
//  SKMopidyRef.h
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/24.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyModel.h"

typedef enum : NSUInteger {
    SKMopidyRefUnknown,
    SKMopidyRefDirectory,
    SKMopidyRefAlbum
} SKMopidyRefType;

@interface SKMopidyRef : SKMopidyModel

@property(nonatomic, assign, readonly) SKMopidyRefType type;

@end
