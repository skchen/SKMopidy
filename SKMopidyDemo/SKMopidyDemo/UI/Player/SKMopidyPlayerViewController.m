//
//  SKMopidyPlayerViewController.m
//  SKMopidyDemo
//
//  Created by Shin-Kai Chen on 2016/4/19.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyPlayerViewController.h"

#import "AppDelegate.h"

#import <SKMopidy/SKMopidy.h>

@interface SKMopidyPlayerViewController ()

@end

@implementation SKMopidyPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    self.player = app.player;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = _ref.name;
    
    __weak __typeof(self.player) weakPlayer = self.player;
    
    [self.player setSource:_ref callback:^(NSError * _Nullable error) {
        if(error) {
            NSLog(@"Unable to set source: %@", error);
        } else {
            if(weakPlayer.state!=SKPlayerPlaying) {
                [weakPlayer start:^(NSError * _Nullable error) {
                    if(error) {
                        NSLog(@"Unable to play source: %@", error);
                    }
                }];
            }
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player stop:^(NSError * _Nullable error) {
        NSLog(@"stop error: %@", error);
    }];
}

@end
