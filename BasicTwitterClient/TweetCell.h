//
//  TweetCell.h
//  BasicTwitterClient
//
//  Created by Tienchai Wirojsaksaree on 11/1/14.
//  Copyright (c) 2014 Tienchai Wirojsaksaree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetCell : UITableViewCell

@property Tweet *tweet;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
