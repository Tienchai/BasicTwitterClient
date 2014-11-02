//
//  Tweet.m
//  BasicTwitterClient
//
//  Created by Tienchai Wirojsaksaree on 11/1/14.
//  Copyright (c) 2014 Tienchai Wirojsaksaree. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    _ID = [dictionary valueForKey:@"id_str"];
    _text = [dictionary valueForKey:@"text"];
    _createdTime = [self _parseDate:[dictionary valueForKey:@"created_at"]];
    _author = [User userWithDictionary:[dictionary valueForKey:@"user"]];
    _retweetCount = [[dictionary valueForKey:@"retweet_count"] unsignedIntegerValue];
    _favouritesCount = [[dictionary valueForKey:@"favourites_count"] unsignedIntegerValue];
    _retweeted = [[dictionary valueForKey:@"retweeted"] boolValue];
    _favourited = [[dictionary valueForKey:@"favorited"] boolValue];
  }
  return self;
}

- (NSDate *)_parseDate:(NSString *)dateString {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
  return [dateFormatter dateFromString:dateString];
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
  NSMutableArray *tweets = [NSMutableArray arrayWithCapacity:array.count];
  for (NSDictionary *dicionary in array) {
    [tweets addObject:[Tweet tweetWithDictionary:dicionary]];
  }
  return tweets;
}

+ (Tweet *)tweetWithDictionary:(NSDictionary *)dictionary {
  return [[self alloc] initWithDictionary:dictionary];
}

@end
