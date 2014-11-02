//
//  SeparatorView.m
//  BasicTwitterClient
//
//  Created by Tienchai Wirojsaksaree on 11/2/14.
//  Copyright (c) 2014 Tienchai Wirojsaksaree. All rights reserved.
//

#import "SeparatorView.h"

@interface SeparatorView ()

@property (nonatomic, strong) UIView *sepearatorView;

@end

@implementation SeparatorView

- (instancetype)init {
  if (self = [super init]) {
    _sepearatorView = [[UIView alloc] init];
    _sepearatorView.backgroundColor = [UIColor grayColor];
    [_sepearatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_sepearatorView];

    [self setNeedsUpdateConstraints];
  }
  return self;
}

- (void)updateConstraints {
  NSDictionary *views = @{@"separatorView": self.sepearatorView};

  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separatorView]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];

  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[separatorView(1)]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];

  [super updateConstraints];
}

@end
