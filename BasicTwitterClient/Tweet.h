//
//  Tweet.h
//  BasicTwitterClient
//
//  Created by Tienchai Wirojsaksaree on 11/1/14.
//  Copyright (c) 2014 Tienchai Wirojsaksaree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong, readonly) NSString *ID;
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSDate *createdTime;
@property (nonatomic, strong, readonly) User *author;
@property (nonatomic, assign, readonly) NSUInteger retweetCount;
@property (nonatomic, assign, readonly) NSUInteger favouritesCount;
@property (nonatomic, assign, readonly) BOOL retweeted;
@property (nonatomic, assign, readonly) BOOL favourited;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)tweetsWithArray:(NSArray *)array;
+ (Tweet *)tweetWithDictionary:(NSDictionary *)dictionary;

@end
