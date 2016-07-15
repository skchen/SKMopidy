//
//  AppDelegate.m
//  SKMopidyDemo
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "AppDelegate.h"

static NSString const * kMopidyIp = @"192.168.2.79";
static const int kMopidyPort = 6680;

@interface AppDelegate () <SKMopidyConnectionDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _connection = [[SKMopidyConnection alloc] initWithIp:kMopidyIp andPort:kMopidyPort];
    _connection.delegate = self;
    [_connection connect];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - SKMopidyConnectionDelegate

- (void)mopidyDidConnected:(nonnull SKMopidyConnection *)connection {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sessionUpdated" object:self];
    
    _player = [[SKMopidyListPlayer alloc] initWithConnection:_connection];
}

- (void)mopidy:(nonnull SKMopidyConnection *)connection failToConnect:(nonnull NSError *)error {
    NSLog(@"failToConnect:%@", error);
    [_connection connect];
}

@end
