//
//  TwitterClient.m
//  BasicTwitterClient
//
//  Created by Tienchai Wirojsaksaree on 11/1/14.
//  Copyright (c) 2014 Tienchai Wirojsaksaree. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

static NSString *kTwitterConsumerKey = @"NHZjZ5Hpz1YvIbWtlppnVsBCu";
static NSString *kTwitterConsumerSecret = @"aJf6BTIyMjPYlxcnY7lAVRy7NB1IUnbuZq2HTUus03w1uzxLBW";

static NSString *kTwitterBaseURL = @"https://api.twitter.com";
static NSString *kTwitterRequestTokenPath = @"/oauth/request_token";

static TwitterClient *_pendingOAuthInstance;
static TwitterClientOAuthSuccessCallback _pendingOAuthSuccessCallback;
static TwitterClientFailureCallback _pendingOAuthFailureCallback;

@implementation TwitterClient

- (void)performOAuthWithSuccess:(TwitterClientOAuthSuccessCallback)success failure:(TwitterClientFailureCallback)failure {
  assert(!_pendingOAuthInstance);
  _pendingOAuthInstance = self;
  _pendingOAuthSuccessCallback = success;
  _pendingOAuthFailureCallback = failure;

  [self.requestSerializer removeAccessToken];
  [self fetchRequestTokenWithPath:@"/oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"basictwitterclient://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
    NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
    [[UIApplication sharedApplication] openURL:authURL];
  } failure:[TwitterClient _genericOAuthFailureCallback]];
}

- (void)getHomeTimelineWithSuccess:(void (^)(NSArray *))success failure:(TwitterClientFailureCallback)failure {
  [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success([Tweet tweetsWithArray:responseObject]);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)postStatusUpdateWithStatus:(NSString *)status success:(TwitterClientCallbackWithTweet)success failure:(TwitterClientFailureCallback)failure {
  [self _postWithUrlString:@"1.1/statuses/update.json" parameters:@{@"status": status} success:success failure:failure];
}

- (void)postDeleteStatusWithTweet:(Tweet *)tweet success:(TwitterClientCallbackWithTweet)success failure:(TwitterClientFailureCallback)failure {
  [self _postWithUrlString:[NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", tweet.ID] parameters:nil success:success failure:failure];
}

- (void)postRetweetWithTweet:(Tweet *)tweet success:(TwitterClientCallbackWithTweet)success failure:(TwitterClientFailureCallback)failure {
  [self _postWithUrlString:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweet.ID] parameters:nil success:success failure:failure];
}

- (void)postFavouriteWithTweet:(Tweet *)tweet success:(TwitterClientCallbackWithTweet)success failure:(TwitterClientFailureCallback)failure {
  [self _postWithUrlString:@"1.1/favorites/create.json" parameters:@{@"id": tweet.ID} success:success failure:failure];
}

- (void)postUnfavouriteWithTweet:(Tweet *)tweet success:(TwitterClientCallbackWithTweet)success failure:(TwitterClientFailureCallback)failure {
  [self _postWithUrlString:@"1.1/favorites/destroy.json" parameters:@{@"id": tweet.ID} success:success failure:failure];
}

- (void)_postWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(TwitterClientCallbackWithTweet)success failure:(TwitterClientFailureCallback)failure {
  [self POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success([Tweet tweetWithDictionary:responseObject]);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

+ (TwitterClient *)sharedInstance {
  static TwitterClient *instance;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseURL] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
  });
  return instance;
}

#pragma mark OAuth

+ (BOOL)openURL:(NSURL *)url {
  if (!_pendingOAuthInstance) {
    return NO;
  }
  TwitterClient *instance = _pendingOAuthInstance;
  [instance fetchAccessTokenWithPath:@"https://api.twitter.com/oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query]  success:^(BDBOAuthToken *accessToken) {
    [instance.requestSerializer saveAccessToken:accessToken];

    [instance GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      TwitterClientOAuthSuccessCallback successCallback = _pendingOAuthSuccessCallback;
      [self _clearPendingOAuth];
      dispatch_async(dispatch_get_main_queue(), ^{
        successCallback([User userWithDictionary:responseObject]);
      });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      [self _genericOAuthFailureCallback](error);
    }];
  } failure:[self _genericOAuthFailureCallback]];
  return YES;
}

+ (void (^)(NSError *))_genericOAuthFailureCallback {
  return ^(NSError *error) {
    TwitterClientFailureCallback failureCallback = _pendingOAuthFailureCallback;
    [self _clearPendingOAuth];
    if (failureCallback) {
      dispatch_async(dispatch_get_main_queue(), ^{
        failureCallback(error);
      });
    }
  };
}

+ (void)_clearPendingOAuth {
  _pendingOAuthInstance = nil;
  _pendingOAuthSuccessCallback = nil;
  _pendingOAuthFailureCallback = nil;
}

@end
