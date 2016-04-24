//
//  SKMopidyBrowse.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyBrowse.h"

#import "SKMopidyConnection.h"

@interface SKMopidyBrowse () <SKMopidyConnectionDelegate>

@property(nonatomic, strong, readonly, nonnull) SKMopidyConnection *connection;

@end

@implementation SKMopidyBrowse

- (nonnull instancetype)initWithConnection:(nonnull SKMopidyConnection *)connection {
    self = [super init];
    
    _connection = connection;
    _connection.delegate = self;
    
    return self;
}

- (nullable NSArray<SKMopidyRef *> *)list:(nullable SKMopidyRef *)parent; {
    id uri = (parent)?(parent.uri):([NSNull null]);
    NSDictionary *parameters = @{
                                 @"uri" : uri
                                 };
    
    SKMopidyRequest *request = [_connection perform:@"core.library.browse" withParameters:parameters];
    
    NSArray *resultArray = request.result;
    if(resultArray) {
        NSMutableArray<SKMopidyRef *> *refList = [[NSMutableArray alloc] init];
        
        for(NSDictionary *resultElement in resultArray) {
            SKMopidyRef *ref = [SKMopidyModel modelWithDictionary:resultElement];
            
            if(ref) {
                [refList addObject:ref];
            }
        }
        
        return refList;
    }
    
    return nil;
}

@end
