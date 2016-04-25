//
//  SKMopidyConnection.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyConnection.h"

#import "SKMopidyEvent.h"

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
    
    _isConnected = NO;
    
    _ip = ip;
    _port = port;
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%d/mopidy/ws", ip, port];
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

- (void)didReceiveResponse:(NSDictionary *)response {
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

- (void)didReceiveEvent:(NSDictionary *)eventDictionary {
    SKMopidyEvent *event = [[SKMopidyEvent alloc] initWithDictionary:eventDictionary];
    
    if([_delegate respondsToSelector:@selector(mopidy:didReceiveEvent:)]) {
        [_delegate mopidy:self didReceiveEvent:event];
    }
}

#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSDictionary *messageDictionary = [self dictionaryForJsonString:message];
    
    if([messageDictionary objectForKey:@"id"]) {
        [self didReceiveResponse:messageDictionary];
    } else if([messageDictionary objectForKey:@"event"]) {
        [self didReceiveEvent:messageDictionary];
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    _isConnected = YES;
    
    if([_delegate respondsToSelector:@selector(mopidyDidConnected:)]) {
        [_delegate mopidyDidConnected:self];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    if([_delegate respondsToSelector:@selector(mopidy:failToConnect:)]) {
        [_delegate mopidy:self failToConnect:error];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    _isConnected = NO;
    
    if([_delegate respondsToSelector:@selector(mopidy:didDisconnected:)]) {
        [_delegate mopidy:self didDisconnected:[NSError errorWithDomain:reason code:code userInfo:nil]];
    }
}

@end
