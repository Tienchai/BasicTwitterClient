//
//  TweetsViewController.m
//  BasicTwitterClient
//
//  Created by Tienchai Wirojsaksaree on 11/1/14.
//  Copyright (c) 2014 Tienchai Wirojsaksaree. All rights reserved.
//

#import "ComposingViewController.h"
#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"
#import "TweetViewController.h"
#import "TweetCell.h"
#import "User.h"

@interface TweetsViewController ()

@property (nonatomic, strong) NSArray *tweets;

@end

@implementation TweetsViewController

- (instancetype)init {
  if (self = [super init]) {
    self.title = @"Home";
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onSignOutButtonTap)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onNewButtonTap)];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(onPullRefresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
  }
  return self;
}

- (void)_updateTweets {
  [self.refreshControl beginRefreshing];
  [[TwitterClient sharedInstance] getHomeTimelineWithSuccess:^(NSArray *tweets) {
    self.tweets = tweets;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
  } failure:^(NSError *error) {
    NSLog(@"Fail to load home timeline: %@", error);
  }];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self _updateTweets];
}

+ (UINavigationController *)tweetsViewControllerWithNavigationController {
  return [[UINavigationController alloc] initWithRootViewController:[[self alloc] init]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
  if (!cell) {
    cell = [[TweetCell alloc] initWithReuseIdentifier:@"TweetCell"];
  }
  cell.tweet = self.tweets[indexPath.row];
  return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.navigationController pushViewController:[[TweetViewController alloc] initWithTweet:self.tweets[indexPath.row]] animated:YES];
}

#pragma mark - Bar Item Handlers

- (void)onSignOutButtonTap {
  [User setCurrentUser:nil];
  [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
  [self presentViewController:[[LoginViewController alloc] init] animated:YES completion:nil];
}

- (void)onNewButtonTap {
  [self.navigationController pushViewController:[[ComposingViewController alloc] initWithReplyingTweet:nil success:^(Tweet *tweet) {
    [self.navigationController pushViewController:[[TweetViewController alloc] initWithTweet:tweet] animated:NO];
  }] animated:YES];
}

#pragma mark - RefreshControl Handler

- (void)onPullRefresh {
  [self _updateTweets];
}

@end
