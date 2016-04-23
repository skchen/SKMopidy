//
//  SKMopidyNode.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyNode.h"

@import SocketRocket;

@interface SKMopidyNode () <SRWebSocketDelegate>

@property(nonatomic, copy, nonnull) NSString *ip;
@property(nonatomic, assign) int port;

@property(nonatomic, strong, nonnull) SRWebSocket *socket;

@end

@implementation SKMopidyNode

- (nonnull instancetype)initWithIp:(NSString *)ip andPort:(int)port {
    self = [super init];
    
    _ip = ip;
    _port = port;
    
    NSString *urlString = [NSString stringWithFormat:@"ws://%@:%d/mopidy/ws", ip, port];
    NSURL *url = [NSURL URLWithString:urlString];
    _socket = [[SRWebSocket alloc] initWithURL:url];
    _socket.delegate = self;
    
    return self;
}

- (void)connect {
    [_socket open];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"webSocket.didReceiveMessage: %@", message);
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
