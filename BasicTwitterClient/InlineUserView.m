//
//  InlineUserView.m
//  BasicTwitterClient
//
//  Created by Tienchai Wirojsaksaree on 11/2/14.
//  Copyright (c) 2014 Tienchai Wirojsaksaree. All rights reserved.
//

#import "InlineUserView.h"
#import "UIImageView+AFNetworking.h"

@interface InlineUserView ()

@property UIImageView *userImageView;
@property UILabel *userNameLabel;
@property UILabel *userScreennameLabel;

@end

@implementation InlineUserView

- (instancetype)init {
  if (self = [super init]) {
    _userImageView = [[UIImageView alloc] init];
    _userImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_userImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_userImageView];

    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.font = [UIFont boldSystemFontOfSize:16];
    [_userNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_userNameLabel];

    _userScreennameLabel = [[UILabel alloc] init];
    _userScreennameLabel.textColor = [UIColor grayColor];
    _userScreennameLabel.font = [UIFont systemFontOfSize:16];
    [_userScreennameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_userScreennameLabel];

    [self setNeedsUpdateConstraints];
  }
  return self;
}

- (void)updateConstraints {
  NSDictionary *views = @{@"userImageView": self.userImageView,
                          @"userNameLabel": self.userNameLabel,
                          @"userScreennameLabel": self.userScreennameLabel,
                          };

  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[userImageView(50)]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];

  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.userImageView
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.userImageView
                                                   attribute:NSLayoutAttributeHeight
                                                  multiplier:1
                                                    constant:0]];

  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[userImageView]-5-[userNameLabel]|"
                                                               options:NSLayoutFormatAlignAllTop
                                                               metrics:nil
                                                                 views:views]];

  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[userNameLabel]-5-[userScreennameLabel]"
                                                               options:NSLayoutFormatAlignAllLeading
                                                               metrics:nil
                                                                 views:views]];

  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[userScreennameLabel]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];



  [super updateConstraints];
}

@synthesize user = _user;

- (void)setUser:(User *)user {
  if (_user != user || ![_user isEqual:user]) {
    _user = user;
    [self.userImageView setImageWithURL:_user.profileImageUrl];
    self.userNameLabel.text = _user.name;
    self.userScreennameLabel.text = _user.screenname;
  }
}

@end
