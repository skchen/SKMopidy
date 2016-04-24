//
//  SKMopidyBrowse.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyBrowse.h"

#import "SKMopidyConnection.h"

@interface SKMopidyBrowse ()

@property(nonatomic, strong, readonly, nonnull) SKMopidyConnection *connection;

@end

@implementation SKMopidyBrowse

- (nonnull instancetype)initWithConnection:(nonnull SKMopidyConnection *)connection {
    self = [super init];
    
    _connection = connection;
    
    return self;
}

- (nullable NSArray<SKMopidyRef *> *)browse:(nullable SKMopidyRef *)parent; {
    return [SKMopidyBrowse browse:parent withConnection:_connection];
}

+ (nullable NSArray<SKMopidyRef *> *)browse:(nullable SKMopidyRef *)parent withConnection:(nonnull SKMopidyConnection *)connection {

    id uri = (parent)?(parent.uri):([NSNull null]);
    NSDictionary *parameters = @{
                                 @"uri" : uri
                                 };
    
    SKMopidyRequest *request = [connection perform:@"core.library.browse" withParameters:parameters];
    
    if(request.result) {
        return request.result;
    }
    
    return nil;
}

+ (nullable SKMopidyModel *)lookup:(nonnull NSString *)uri withConnection:(nonnull SKMopidyConnection *)connection {
    
    NSDictionary *parameters = @{
                                 @"uri" : uri
                                 };
    
    SKMopidyRequest *request = [connection perform:@"core.library.lookup" withParameters:parameters];
    
    NSArray *resultArray = request.result;
    if(resultArray && [resultArray count]>0) {
        return [SKMopidyModel modelWithDictionary:[resultArray objectAtIndex:0]];
    }
    
    return nil;
}

@end
