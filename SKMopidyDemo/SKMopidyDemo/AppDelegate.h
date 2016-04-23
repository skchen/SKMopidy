//
//  AppDelegate.h
//  SKMopidyDemo
//
//  Created by Shin-Kai Chen on 2016/4/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <UIKit/UIKit.h>

@import SKMopidy;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SKMopidyPlayer *player;

@end

