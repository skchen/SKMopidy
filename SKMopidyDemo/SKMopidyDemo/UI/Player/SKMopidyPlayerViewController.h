//
//  SKMopidyPlayerViewController.h
//  SKMopidyDemo
//
//  Created by Shin-Kai Chen on 2016/4/20.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <SKUtils/SKUtils.h>

@class SKMopidyRef;

@interface SKMopidyPlayerViewController : SKListPlayerViewController

@property(nonatomic, strong, nullable) SKMopidyRef *ref;


@end

