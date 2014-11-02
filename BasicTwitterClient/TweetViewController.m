//
//  TweetViewController.m
//  BasicTwitterClient
//
//  Created by Tienchai Wirojsaksaree on 11/2/14.
//  Copyright (c) 2014 Tienchai Wirojsaksaree. All rights reserved.
//

#import "ComposingViewController.h"
#import "TweetViewController.h"
#import "InlineUserView.h"
#import "SeparatorView.h"
#import "TwitterClient.h"

@interface TweetViewController ()

@property (nonatomic, strong) Tweet *tweet;

@property (nonatomic, strong) InlineUserView *authorView;
@property (nonatomic, strong) UILabel *tweetTextLabel;
@property (nonatomic, strong) UILabel *createdTimeLabel;

@property (nonatomic, strong) SeparatorView *firstSeparatorView;

@property (nonatomic, strong) UILabel *countsLabel;

@property (nonatomic, strong) SeparatorView *secondSeparatorView;

@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, strong) UIButton *retweetButton;
@property (nonatomic, strong) UIButton *favouriteButton;

@property SeparatorView *thirdSeparatorView;

@end

@implementation TweetViewController

- (instancetype)initWithTweet:(Tweet *)tweet {
  if (self = [super init]) {
    self.title = @"Tweet";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(onReplyButtonTap)];
    _authorView = [[InlineUserView alloc] init];
    [_authorView setTranslatesAutoresizingMaskIntoConstraints:NO];

    _tweetTextLabel = [[UILabel alloc] init];
    _tweetTextLabel.font = [UIFont systemFontOfSize:16];
    _tweetTextLabel.numberOfLines = 0;
    [_tweetTextLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    _createdTimeLabel = [[UILabel alloc] init];
    _createdTimeLabel.textColor = [UIColor grayColor];
    _createdTimeLabel.font = [UIFont systemFontOfSize:14];
    [_createdTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    _firstSeparatorView = [[SeparatorView alloc] init];
    [_firstSeparatorView setTranslatesAutoresizingMaskIntoConstraints:NO];

    _countsLabel = [[UILabel alloc] init];
    _countsLabel.font = [UIFont systemFontOfSize:14];
    [_countsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    _secondSeparatorView = [[SeparatorView alloc] init];
    [_secondSeparatorView setTranslatesAutoresizingMaskIntoConstraints:NO];

    _replyButton = [[UIButton alloc] init];
    [_replyButton setImage:[UIImage imageNamed:@"reply"] forState:UIControlStateNormal];
    [_replyButton setImage:[UIImage imageNamed:@"reply_hover"] forState:UIControlStateHighlighted];
    [_replyButton addTarget:self action:@selector(onReplyButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [_replyButton setTranslatesAutoresizingMaskIntoConstraints:NO];

    _retweetButton = [[UIButton alloc] init];
    [_retweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
    [_retweetButton setImage:[UIImage imageNamed:@"retweet_hover"] forState:UIControlStateHighlighted];
    [_retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateSelected | UIControlStateDisabled];
    [_retweetButton addTarget:self action:@selector(onRetweetButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [_retweetButton setTranslatesAutoresizingMaskIntoConstraints:NO];

    _favouriteButton = [[UIButton alloc] init];
    [_favouriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    [_favouriteButton setImage:[UIImage imageNamed:@"favorite_hover"] forState:UIControlStateHighlighted];
    [_favouriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateSelected];
    [_favouriteButton addTarget:self action:@selector(onFavouriteButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [_favouriteButton setTranslatesAutoresizingMaskIntoConstraints:NO];

    _thirdSeparatorView = [[SeparatorView alloc] init];
    [_thirdSeparatorView setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.tweet = tweet;
  }
  return self;
}

- (void)loadView {
  [super loadView];
  self.view.backgroundColor = [UIColor whiteColor];

  [self.view addSubview:self.authorView];
  [self.view addSubview:self.tweetTextLabel];
  [self.view addSubview:self.createdTimeLabel];
  [self.view addSubview:self.firstSeparatorView];
  [self.view addSubview:self.countsLabel];
  [self.view addSubview:self.secondSeparatorView];
  [self.view addSubview:self.replyButton];
  [self.view addSubview:self.retweetButton];
  [self.view addSubview:self.favouriteButton];
  [self.view addSubview:self.thirdSeparatorView];

  [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {

  NSDictionary *views = @{@"authorView": self.authorView,
                          @"tweetTextlabel": self.tweetTextLabel,
                          @"createdTimeLabel": self.createdTimeLabel,
                          @"firstSeparatorView": self.firstSeparatorView,
                          @"countsLabel": self.countsLabel,
                          @"secondSeparatorView": self.secondSeparatorView,
                          @"replyButton": self.replyButton,
                          @"retweetButton": self.retweetButton,
                          @"favouriteButton": self.favouriteButton,
                          @"thirdSeparatorView": self.thirdSeparatorView,
                          };

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-74-[authorView]-10-[tweetTextlabel]-10-[createdTimeLabel]-10-[firstSeparatorView]-10-[countsLabel]-10-[secondSeparatorView]"
                                                                    options:NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing
                                                                    metrics:nil
                                                                      views:views]];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[secondSeparatorView]-10-[replyButton]-10-[thirdSeparatorView]-(>=10)-|"
                                                                    options:NSLayoutFormatAlignAllLeading
                                                                    metrics:nil
                                                                      views:views]];

  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.secondSeparatorView
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.thirdSeparatorView
                                                        attribute:NSLayoutAttributeTrailing
                                                       multiplier:1
                                                         constant:0]];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[authorView]-10-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views]];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[replyButton]-100-[retweetButton]-100-[favouriteButton]-(>=10)-|"
                                                                    options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
                                                                    metrics:nil
                                                                      views:views]];

  [super updateViewConstraints];
}

@synthesize tweet = _tweet;

- (void)setTweet:(Tweet *)tweet {
  if (_tweet != tweet && ![_tweet isEqual:tweet]) {
    _tweet = tweet;
    self.authorView.user = _tweet.author;
    self.tweetTextLabel.text = _tweet.text;
    self.createdTimeLabel.text = [self _formatCreatedTime:_tweet.createdTime];
    self.countsLabel.text = [NSString stringWithFormat:@"%lu RETWEETS   %lu FAVOURITES", (unsigned long)_tweet.retweetCount, (unsigned long)_tweet.favouritesCount];
    self.retweetButton.enabled = !_tweet.retweeted && ![_tweet.author isEqualToUser:[User currentUser]];
    self.retweetButton.selected = _tweet.retweeted;
    self.favouriteButton.selected = _tweet.favourited;
  }
}

- (NSString *)_formatCreatedTime:(NSDate *)createdTime {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"M/dd/yy, hh:mm a";
  return [formatter stringFromDate:createdTime];
}

- (void)onReplyButtonTap {
  [self.navigationController pushViewController:[[ComposingViewController alloc] initWithReplyingTweet:self.tweet success:^(Tweet *tweet) {
    self.tweet = tweet;
  }] animated:YES];
}

- (TwitterClientCallbackWithTweet)_getSuccessCallbackWithTweet {
  return ^(Tweet *tweet) {
    self.tweet = tweet;
  };
}

- (void)onRetweetButtonTap {
  [[TwitterClient sharedInstance] postRetweetWithTweet:self.tweet success:[self _getSuccessCallbackWithTweet] failure:^(NSError *error) {
    NSLog(@"Failed to retweet: %@", error);
  }];
}

- (void)onFavouriteButtonTap {
  TwitterClient *tc = [TwitterClient sharedInstance];
  TwitterClientCallbackWithTweet success = [self _getSuccessCallbackWithTweet];
  if (self.tweet.favourited) {
    [tc postUnfavouriteWithTweet:self.tweet success:success failure:^(NSError *error) {
      NSLog(@"Failed to unfavourite: %@", error);
    }];
  } else {
    [tc postFavouriteWithTweet:self.tweet success:success failure:^(NSError *error) {
      NSLog(@"Failed to favourite: %@", error);
    }];
  }
}

@end
