//
//  TweetCell.m
//  BasicTwitterClient
//
//  Created by Tienchai Wirojsaksaree on 11/1/14.
//  Copyright (c) 2014 Tienchai Wirojsaksaree. All rights reserved.
//

#import "TweetCell.h"
#import "NSDate+DateTools.h"
#import "UIImageView+AFNetworking.h"

@interface TweetCell ()

@property (nonatomic, strong, readonly) UIImageView *authorImageView;

@property (nonatomic, strong, readonly) UILabel *authorNameLabel;
@property (nonatomic, strong, readonly) UILabel *authorScreennameLabel;
@property (nonatomic, strong, readonly) UILabel *createdTimeLabel;

@property (nonatomic, strong, readonly) UILabel *tweetTextLabel;

@end

@implementation TweetCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
    _authorImageView = [[UIImageView alloc] init];
    _authorImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_authorImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_authorImageView];

    _authorNameLabel = [[UILabel alloc] init];
    _authorNameLabel.font = [UIFont boldSystemFontOfSize:12];
    [_authorNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_authorNameLabel];

    _authorScreennameLabel = [[UILabel alloc] init];
    _authorScreennameLabel.textColor = [UIColor grayColor];
    _authorScreennameLabel.font = [UIFont systemFontOfSize:12];
    [_authorScreennameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_authorScreennameLabel];

    _createdTimeLabel = [[UILabel alloc] init];
    _createdTimeLabel.textColor = [UIColor grayColor];
    _createdTimeLabel.font = [UIFont systemFontOfSize:12];
    _createdTimeLabel.textAlignment = NSTextAlignmentRight;
    [_createdTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_createdTimeLabel];

    _tweetTextLabel = [[UILabel alloc] init];
    _tweetTextLabel.numberOfLines = 2;
    _tweetTextLabel.font = [UIFont systemFontOfSize:12];
    [_tweetTextLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_tweetTextLabel];

    [self setNeedsUpdateConstraints];
  }
  return self;
}

- (void)updateConstraints {
  NSDictionary *views = @{@"authorImageView": self.authorImageView,
                          @"authorNameLabel": self.authorNameLabel,
                          @"authorScreennameLabel": self.authorScreennameLabel,
                          @"createdTimeLabel": self.createdTimeLabel,
                          @"tweetTextLabel": self.tweetTextLabel,
                          };

  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[authorImageView(50)]-(>=5)-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];

  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.authorImageView
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.authorImageView
                                                               attribute:NSLayoutAttributeHeight
                                                              multiplier:1
                                                                constant:0]];

  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[authorImageView]-5-[authorNameLabel]-5-[authorScreennameLabel]-(>=5)-[createdTimeLabel]-5-|"
                                                                           options:NSLayoutFormatAlignAllTop
                                                                           metrics:nil
                                                                             views:views]];

  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[authorNameLabel]-0-[tweetTextLabel]-(>=5)-|"
                                                                           options:NSLayoutFormatAlignAllLeading
                                                                           metrics:nil
                                                                             views:views]];

  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[tweetTextLabel]-(>=5)-|"
                                                                           options:NSLayoutFormatAlignAllLeading
                                                                           metrics:nil
                                                                             views:views]];

  [super updateConstraints];
}

#pragma mark - Tweet

@synthesize tweet = _tweet;

- (void)setTweet:(Tweet *)tweet {
  if (![tweet isEqual:_tweet]) {
    _tweet = tweet;
    [self.authorImageView setImageWithURL:tweet.author.profileImageUrl];

    self.authorNameLabel.text = tweet.author.name;
    [self.authorNameLabel sizeToFit];

    self.authorScreennameLabel.text = tweet.author.screenname;
    [self.authorScreennameLabel sizeToFit];

    self.createdTimeLabel.text = tweet.createdTime.shortTimeAgoSinceNow;
    [self.createdTimeLabel sizeToFit];

    self.tweetTextLabel.text = tweet.text;
    [self.tweetTextLabel sizeToFit];
  }
}

- (Tweet *)tweet {
  return _tweet;
}

@end
