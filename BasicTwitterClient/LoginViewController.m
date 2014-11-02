//
//  LoginViewController.m
//  BasicTwitterClient
//
//  Created by Tienchai Wirojsaksaree on 11/1/14.
//  Copyright (c) 2014 Tienchai Wirojsaksaree. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"
#import "User.h"

@interface LoginViewController ()

@property UIButton *loginButton;

@end

@implementation LoginViewController

- (instancetype)init {
  if (self = [super init]) {
    _loginButton = [[UIButton alloc] init];
    [_loginButton setTitle:@"Login with Twitter" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0.5 alpha:0.5] forState:UIControlStateNormal];
    [_loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_loginButton addTarget:self action:@selector(onLoginButtonTap) forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (void)loadView {
  [super loadView];
  self.view.backgroundColor = [UIColor whiteColor];

  [self.view addSubview:self.loginButton];
  
  [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1
                                                         constant:0]];
  [super updateViewConstraints];
}

- (void)onLoginButtonTap {
  [[TwitterClient sharedInstance] performOAuthWithSuccess:^(User *user) {
    [User setCurrentUser:user];
    [self presentViewController:[TweetsViewController tweetsViewControllerWithNavigationController] animated:YES completion:nil];
  } failure:^(NSError *error) {
    NSLog(@"Failure with error: %@", error);
  }];
}

@end
