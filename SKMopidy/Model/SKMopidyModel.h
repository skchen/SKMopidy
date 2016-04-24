//
//  SKMopidyModel.h
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/24.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKMopidyModel : NSObject

@property(nonatomic, copy, readonly, nonnull) NSString *name;
@property(nonatomic, copy, readonly, nonnull) NSString *uri;

+ (nullable instancetype)modelWithDictionary:(nonnull NSDictionary *)dictionary;

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;

+ (nullable id)format:(nonnull id)original;


@end
