//
//  SKMopidyModel.h
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/24.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKMopidyModel : NSObject

+ (nullable instancetype)modelWithDictionary:(nonnull NSDictionary *)dictionary;
- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;

@end
