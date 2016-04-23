//
//  SKMopidyPlaybackTableViewController.m
//  SKMopidyDemo
//
//  Created by Shin-Kai Chen on 2016/4/21.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyPlaybackTableViewController.h"

#import "SKMopidyPlayerViewController.h"

@interface SKMopidyPlaybackTableViewController ()

@property(nonatomic, strong, nullable) NSArray *resources;

@end

@implementation SKMopidyPlaybackTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionUpdatedNotification:) name:@"sessionUpdated" object:nil];
    
    [self queryAndShow];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_resources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SKMopidyPlaybackTableViewCell"];
    
    return cell;
}

#pragma mark - Misc

- (void)queryAndShow {
    
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    SKMopidyPlayerViewController *destinationViewController = segue.destinationViewController;
}

#pragma mark - NSNotification

-(void)sessionUpdatedNotification:(NSNotification *)notification {
    [self queryAndShow];
}

@end
