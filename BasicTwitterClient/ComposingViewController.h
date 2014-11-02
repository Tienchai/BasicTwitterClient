//
//  ComposingViewController.h
//  BasicTwitterClient
//
//  Created by Tienchai Wirojsaksaree on 11/2/14.
//  Copyright (c) 2014 Tienchai Wirojsaksaree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface ComposingViewController : UIViewController

- (instancetype)initWithReplyingTweet:(Tweet *)tweet success:(void (^)(Tweet *tweet))success;

@end
