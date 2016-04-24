//
//  SKMopidyRequest.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyRequest.h"

#import "SKMopidyModel.h"

@interface SKMopidyRequest ()

@property(nonatomic, copy, readonly) dispatch_semaphore_t semaphore;

@end

@implementation SKMopidyRequest

- (nonnull instancetype)initWithId:(NSUInteger)id andMethod:(nonnull NSString *)method andParameters:(nullable NSDictionary *)parameters {
    
    self = [super init];
    
    _id = id;
    _method = method;
    _parameters = parameters;
    
    _semaphore = dispatch_semaphore_create(0);
    
    return self;
}

- (void)await {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
}

- (void)notify {
    dispatch_semaphore_signal(_semaphore);
}

- (void)setErrorByDictionary:(nonnull NSDictionary *)dictionary {
    NSString *errorMessage = [dictionary objectForKey:@"message"];
    NSInteger errorCode = [[dictionary objectForKey:@"code"] integerValue];
    NSDictionary *errorInfo = [dictionary objectForKey:@"data"];
    
    _error = [NSError errorWithDomain:errorMessage code:errorCode userInfo:errorInfo];
    [self notify];
}

- (void)setError:(NSError *)error {
    _error = error;
    [self notify];
}

- (void)setResult:(id)result {
    _result = [SKMopidyModel format:result];
    [self notify];
}

- (nullable NSData *)requestData {
    NSMutableDictionary *request = [[NSMutableDictionary alloc] initWithDictionary:@{@"jsonrpc" : @"2.0", @"id" : @(_id), @"method" : _method}];
    
    if(_parameters) {
        [request setObject:_parameters forKey:@"params"];
    }
    
    return [self jsonForDictionary:request];
}

#pragma mark - Misc

- (nullable NSData *)jsonForDictionary:(NSDictionary *)dict {
    NSError *jsonParseError = nil;
    
    NSData *json = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&jsonParseError];
    
    if(jsonParseError) {
        NSLog(@"Unable to generate JSON string: %@", jsonParseError);
    }
    
    return json;
}

@end
