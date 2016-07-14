//
//  SKMopidyPlaybackTableViewController.m
//  SKMopidyDemo
//
//  Created by Shin-Kai Chen on 2016/4/21.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyPlaybackTableViewController.h"

#import "SKMopidyPlayerViewController.h"
#import "AppDelegate.h"

#import <SKMopidy/SKMopidy.h>

@interface SKMopidyPlaybackTableViewController ()

@property(nonatomic, strong, nonnull) SKMopidyBrowse *browser;
@property(nonatomic, strong, nullable) NSArray *resources;
@property(nonatomic, strong, nullable) NSMutableArray *refs;

@property(nonatomic, strong, nonnull) SKMopidyConnection *connection;

@end

@implementation SKMopidyPlaybackTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _refs = [[NSMutableArray alloc] init];
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    _connection = app.connection;
    _browser = [[SKMopidyBrowse alloc] initWithConnection:_connection];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionUpdatedNotification:) name:@"sessionUpdated" object:nil];
    
    if([_connection isConnected]) {
        [self queryAndShow];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch(section) {
        case 0:
            return ([_refs count]>0)?(1):(0);
            
        case 1:
            return [_resources count];
            
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SKMopidyPlaybackTableViewCell"];
    
    
    switch(indexPath.section) {
        case 0:
            [cell.textLabel setText:@".."];
            break;
            
        case 1: {
            SKMopidyRef *ref = [_resources objectAtIndex:indexPath.row];
            [cell.textLabel setText:ref.name];
        }
            
        default:
            break;
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch(indexPath.section) {
        case 0:
            [_refs removeLastObject];
            [self queryAndShow];
            break;
            
        case 1: {
            SKMopidyRef *ref = [_resources objectAtIndex:indexPath.row];
            if( (ref.type==SKMopidyRefDirectory) || (ref.type==SKMopidyRefAlbum) ) {
                [_refs addObject:ref];
                [self queryAndShow];
            }
        }
            
        default:
            break;
    }
}

#pragma mark - Misc

- (void)queryAndShow {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _resources = [_browser browse:[_refs lastObject]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    switch(indexPath.section) {
        case 0:
            return NO;
            
        case 1: {
            SKMopidyRef *ref = [_resources objectAtIndex:indexPath.row];
            if( (ref.type==SKMopidyRefDirectory) || (ref.type==SKMopidyRefAlbum) ) {
                return NO;
            }
        }
            break;
            
        default:
            break;
    }
    
    
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    SKMopidyPlayerViewController *destinationViewController = segue.destinationViewController;
    
    destinationViewController.ref = [_resources objectAtIndex:indexPath.row];
}

#pragma mark - NSNotification

-(void)sessionUpdatedNotification:(NSNotification *)notification {
    [self queryAndShow];
}

@end
