//
//  ComposingViewController.m
//  BasicTwitterClient
//
//  Created by Tienchai Wirojsaksaree on 11/2/14.
//  Copyright (c) 2014 Tienchai Wirojsaksaree. All rights reserved.
//

#import "ComposingViewController.h"
#import "InlineUserView.h"
#import "TwitterClient.h"
#import "User.h"

@interface ComposingViewController ()

@property (nonatomic, strong) Tweet *replyingTweet;
@property (nonatomic, copy) void (^successCallback)(Tweet *);

@property InlineUserView *authorView;
@property UITextView *composingTextView;

@end

@implementation ComposingViewController

- (instancetype)init {
  return [self initWithReplyingTweet:nil success:nil];
}

- (instancetype)initWithReplyingTweet:(Tweet *)tweet success:(void (^)(Tweet *))success {
  if (self = [super init]) {
    _replyingTweet = tweet;
    _successCallback = success;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onTweetButtonTap)];

    _authorView = [[InlineUserView alloc] init];
    _authorView.user = [User currentUser];
    [_authorView setTranslatesAutoresizingMaskIntoConstraints:NO];

    _composingTextView = [[UITextView alloc] init];
    if (_replyingTweet) {
      _composingTextView.text = [NSString stringWithFormat:@"%@ ", tweet.author.screenname];
    }
    [_composingTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  return self;
}

- (void)loadView {
  [super loadView];

  self.view.backgroundColor = [UIColor whiteColor];

  [self.view addSubview:self.authorView];
  [self.view addSubview:self.composingTextView];

  [self.view setNeedsUpdateConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.composingTextView becomeFirstResponder];
}

- (void)updateViewConstraints {
  NSDictionary *views = @{@"authorView": self.authorView,
                          @"composingTextView": self.composingTextView,
                          };

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-69-[authorView]-5-[composingTextView]-5-|"
                                                                    options:NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing
                                                                    metrics:nil
                                                                      views:views]];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[authorView]-5-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views]];

  [super updateViewConstraints];
}

- (void)onTweetButtonTap {
  [[TwitterClient sharedInstance] postStatusUpdateWithStatus:self.composingTextView.text success:^(Tweet *tweet){
    [self.navigationController popViewControllerAnimated:NO];
    if (_successCallback) {
      _successCallback(tweet);
    }
  } failure:^(NSError *error) {
    NSLog(@"Failed to post statust update: %@", error);
  }];
}

@end
