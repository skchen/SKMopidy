//
//  SKMopidyModel.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/24.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyModel.h"

static NSString const * kKeyModel = @"__model__";
static NSString const * kModelPrefix = @"SKMopidy";

@implementation SKMopidyModel

+ (nullable instancetype)modelWithDictionary:(nonnull NSDictionary *)dictionary {
    NSString *model = [dictionary objectForKey:kKeyModel];
    if(model) {
        NSString *className = [NSString stringWithFormat:@"%@%@", kModelPrefix, model];
        return [[NSClassFromString(className) alloc] initWithDictionary:dictionary];
    }
    
    return nil;
}

@end
