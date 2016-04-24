//
//  SKMopidyRequest.h
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKMopidyRequest : NSObject

@property(nonatomic, readonly) NSUInteger id;
@property(nonatomic, copy, readonly, nonnull) NSString *method;
@property(nonatomic, strong, readonly, nullable) NSDictionary *parameters;

@property(nonatomic, strong, nullable) NSError *error;
@property(nonatomic, strong, nullable) id result;

- (nonnull instancetype)initWithId:(NSUInteger)id andMethod:(nonnull NSString *)method andParameters:(nullable NSDictionary *)parameters;

- (void)await;

- (nullable NSData *)requestData;

- (void)setErrorByDictionary:(nonnull NSDictionary *)dictionary;

@end
