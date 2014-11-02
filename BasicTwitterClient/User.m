//
//  User.m
//  BasicTwitterClient
//
//  Created by Tienchai Wirojsaksaree on 11/1/14.
//  Copyright (c) 2014 Tienchai Wirojsaksaree. All rights reserved.
//

#import "User.h"

@implementation User

#pragma mark - Creation

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    _ID = [dictionary valueForKey:@"id_str"];
    _name = [dictionary valueForKey:@"name"];
    _screenname = [NSString stringWithFormat:@"@%@", [dictionary valueForKey:@"screen_name"]];
    _profileImageUrl = [NSURL URLWithString:[dictionary valueForKey:@"profile_image_url_https"]];
    _tagline = [dictionary valueForKey:@"description"];
  }
  return self;
}

+ (instancetype)userWithDictionary:(NSDictionary *)dictionary {
  return [[self alloc] initWithDictionary:dictionary];
}

#pragma mark - NSCoder

static NSString *kIDKey = @"kIDKey";
static NSString *kNameKey = @"kNameKey";
static NSString *kScreennameKey = @"kScreennameKey";
static NSString *kProfileImageUrlKey = @"kProfileImageUrlKey";
static NSString *kTaglineKey = @"kTaglineKey";

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    _ID = [aDecoder decodeObjectForKey:kIDKey];
    _name = [aDecoder decodeObjectForKey:kNameKey];
    _screenname = [aDecoder decodeObjectForKey:kScreennameKey];
    _profileImageUrl = [aDecoder decodeObjectForKey:kProfileImageUrlKey];
    _tagline = [aDecoder decodeObjectForKey:kTaglineKey];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.ID forKey:kIDKey];
  [aCoder encodeObject:self.name forKey:kNameKey];
  [aCoder encodeObject:self.screenname forKey:kScreennameKey];
  [aCoder encodeObject:self.profileImageUrl forKey:kProfileImageUrlKey];
  [aCoder encodeObject:self.tagline forKey:kTaglineKey];
}

#pragma mark - equilities

- (BOOL)isEqual:(id)object {
  if (self == object) {
    return YES;
  }
  if (![object isKindOfClass:self.class]) {
    return NO;
  }
  return [self isEqualToUser:object];
}

- (BOOL)isEqualToUser:(User *)user {
  return [self.ID isEqual:user.ID];
}

- (NSUInteger)hash {
  return self.ID.hash;
}

#pragma mark - Current user

static User *_currentUser;
static NSString *kCurrentUserKey = @"kCurrentUserKey";

+ (User *)currentUser {
  if (!_currentUser) {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
    if (data) {
      _currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
  }

  return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
  _currentUser = currentUser;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_currentUser] forKey:kCurrentUserKey];
  [defaults synchronize];
}

@end
