//
//  User.h
//  BasicTwitterClient
//
//  Created by Tienchai Wirojsaksaree on 11/1/14.
//  Copyright (c) 2014 Tienchai Wirojsaksaree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>

@property (nonatomic, strong, readonly) NSString *ID;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *screenname;
@property (nonatomic, strong, readonly) NSURL *profileImageUrl;
@property (nonatomic, strong, readonly) NSString *tagline;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)isEqualToUser:(User *)user;

+ (instancetype)userWithDictionary:(NSDictionary *)dictionary;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;

@end
