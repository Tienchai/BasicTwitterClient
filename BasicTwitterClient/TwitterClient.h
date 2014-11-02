//
//  TwitterClient.h
//  BasicTwitterClient
//
//  Created by Tienchai Wirojsaksaree on 11/1/14.
//  Copyright (c) 2014 Tienchai Wirojsaksaree. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

typedef void(^TwitterClientOAuthSuccessCallback)(User *user);
typedef void(^TwitterClientCallbackWithTweet)(Tweet *tweet);
typedef void(^TwitterClientFailureCallback)(NSError *error);

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;
+ (BOOL)openURL:(NSURL *)url;

- (void)performOAuthWithSuccess:(TwitterClientOAuthSuccessCallback)success failure:(TwitterClientFailureCallback)failure;
- (void)getHomeTimelineWithSuccess:(void (^)(NSArray *tweets))success failure:(TwitterClientFailureCallback)failure;

- (void)postStatusUpdateWithStatus:(NSString *)status success:(TwitterClientCallbackWithTweet)success failure:(TwitterClientFailureCallback)failure;
- (void)postDeleteStatusWithTweet:(Tweet *)tweet success:(TwitterClientCallbackWithTweet)success failure:(TwitterClientFailureCallback)failure;
- (void)postRetweetWithTweet:(Tweet *)tweet success:(TwitterClientCallbackWithTweet)success failure:(TwitterClientFailureCallback)failure;
- (void)postFavouriteWithTweet:(Tweet *)tweet success:(TwitterClientCallbackWithTweet)success failure:(TwitterClientFailureCallback)failure;
- (void)postUnfavouriteWithTweet:(Tweet *)tweet success:(TwitterClientCallbackWithTweet)success failure:(TwitterClientFailureCallback)failure;

@end
