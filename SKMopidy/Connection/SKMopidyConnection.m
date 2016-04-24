//
//  SKMopidyConnection.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyConnection.h"

@import SocketRocket;

@interface SKMopidyConnection () <SRWebSocketDelegate>

@property(nonatomic, copy, nonnull) NSString *ip;
@property(nonatomic, assign) int port;

@property(nonatomic, strong, nonnull) SRWebSocket *socket;
@property(nonatomic, assign, readonly) int requestId;

@property(nonatomic, strong, nonnull) NSMutableDictionary *pendingReuqests;

@end

@implementation SKMopidyConnection

- (nonnull instancetype)initWithIp:(NSString *)ip andPort:(int)port {
    self = [super init];
    
    _ip = ip;
    _port = port;
    
    NSString *urlString = [NSString stringWithFormat:@"ws://%@:%d/mopidy/ws", ip, port];
    NSURL *url = [NSURL URLWithString:urlString];
    _socket = [[SRWebSocket alloc] initWithURL:url];
    _socket.delegate = self;
    [_socket setDelegateDispatchQueue:dispatch_queue_create("com.github.skchen.SKMopidyConnection.socket", NULL)];
    
    _requestId = 0;
    
    _pendingReuqests = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (void)connect {
    [_socket open];
}

- (nonnull SKMopidyRequest *)perform:(nonnull NSString *)method {
    return [self perform:method withParameters:nil];
}

- (nonnull SKMopidyRequest *)perform:(nonnull NSString *)method withParameters:(nullable NSDictionary *)parameters {
    
    NSUInteger id = [self acquireRequestId];
    
    SKMopidyRequest *request = [[SKMopidyRequest alloc] initWithId:id andMethod:method andParameters:parameters];
    
    NSData *json = [request requestData];
    if(json) {
        [_socket send:json];
        [_pendingReuqests setObject:request forKey:@(id)];
        [request await];
    } else {
        request.error = [NSError errorWithDomain:@"Unable to generate request" code:0 userInfo:nil];
    }
    
    return request;
}

#pragma mark - Misc

- (NSUInteger)acquireRequestId {
    @synchronized(self) {
        NSUInteger requestId = _requestId;
        _requestId++;
        return requestId;
    }
}

- (nullable NSDictionary *)dictionaryForJsonString:(nonnull NSString *)jsonString {
    NSError *jsonParseError = nil;
    
    NSData *json = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:0 error:&jsonParseError];
    
    if(jsonParseError) {
        NSLog(@"Unable to parse json: %@", jsonParseError);
    }
    
    return dictionary;
}

#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"webSocket.didReceiveMessage: %@", message);
    
    NSDictionary *response = [self dictionaryForJsonString:message];
    NSUInteger requestId = [[response objectForKey:@"id"] unsignedIntegerValue];
    
    SKMopidyRequest *request = [_pendingReuqests objectForKey:@(requestId)];
    if(request) {
        NSDictionary *result = [response objectForKey:@"result"];
        if(result) {
            [request setResult:result];
        } else {
            NSDictionary *errorDictionary = [response objectForKey:@"error"];
            [request setErrorByDictionary:errorDictionary];
        }
        
        [_pendingReuqests removeObjectForKey:@(requestId)];
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"webSocketDidOpen");
    
    [_delegate mopidyDidConnected:self];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"webSocket.didFailWithError:%@", error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {

    NSLog(@"webSocket.didCloseWithCode:%@ reason:%@ wasClean:%@", @(code), reason, @(wasClean));
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSLog(@"webSocket.didReceivePong:%@", pongPayload);
}

@end