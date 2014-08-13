//
//  MapizUser.m
//  Mapiz
//
//  Created by samuel on 10/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizUser.h"
#import "JNKeychain.h"


@implementation MapizUser

NSString * const USERS_COLLECTION_NAME = @"users";

static NSString* KEY_AUTH_USER_TOKEN = @"co.mapiz.auth.token";
static NSString* KEY_AUTH_USER_TOKEN_EXPIRES = @"co.mapiz.auth.token_expires";
static NSString* KEY_AUTH_USER_ID = @"co.mapiz.auth.id";
static NSString* KEY_AUTH_USER_USERNAME = @"co.mapiz.auth.username";
static NSString* KEY_AUTH_USER_EMAIL = @"co.mapiz.auth.email";
static NSString* KEY_AUTH_USER_DISPLAY_NAME = @"co.mapiz.auth.display_name";
static NSString* KEY_AUTH_USER_PIN_COLOUR = @"co.mapiz.auth.pin_colour";

static NSString* FIELD_ID = @"_id";
static NSString* FIELD_USERNAME = @"username";
static NSString* FIELD_DISPLAY_NAME = @"profile.display_name";

static MapizUser* loggedInUser = nil;

@synthesize _id;
@synthesize username;
@synthesize displayName;
@synthesize email;
@synthesize token;

- (id)initWithResponse:(NSDictionary *)dictionary {
  self = [super init];
  
  if(self) {
    self._id = [dictionary valueForKeyPath:FIELD_ID];
    self.username = [dictionary valueForKeyPath:FIELD_USERNAME];
    self.displayName = [dictionary valueForKeyPath:FIELD_DISPLAY_NAME];
  }
  
  return self;
}

+ (void) callMyFriends: (MeteorClientMethodCallback) responseCallback {
  [[MapizDDPClient getInstance] callMethodName:@"myFriends" parameters:@[] responseCallback: responseCallback];
}

+ (void) callAddFriend: (NSString *) username responseCallback:(MeteorClientMethodCallback) responseCallback {
    [[MapizDDPClient getInstance] callMethodName:@"addFriend" parameters:@[username] responseCallback: responseCallback];
}

+ (void) callMyInbox: (MeteorClientMethodCallback) responseCallback {
  [[MapizDDPClient getInstance] callMethodName:@"myInbox" parameters:@[] responseCallback:responseCallback];
}

+ (void) saveAuthUserWithToken: (NSString *) token
                       expires: (NSDate *) expires
                            _id: (NSString *) _id
                      username: (NSString *) username
                         email: (NSString *) email
                   displayName: (NSString *) displayName {
  
  [JNKeychain saveValue:token forKey: KEY_AUTH_USER_TOKEN];
  [JNKeychain saveValue:expires forKey: KEY_AUTH_USER_TOKEN_EXPIRES];
  [JNKeychain saveValue:_id forKey: KEY_AUTH_USER_ID];
  [JNKeychain saveValue:username forKey: KEY_AUTH_USER_USERNAME];
  [JNKeychain saveValue:email forKey: KEY_AUTH_USER_EMAIL];
  [JNKeychain saveValue:displayName forKey: KEY_AUTH_USER_DISPLAY_NAME];
                     
  [self initAuthUser];
  
}

+ (void) saveAuthUserProfileWithUsername:(NSString *)username email:(NSString *)email displayName:(NSString *)displayName {
  [JNKeychain saveValue:username forKey: KEY_AUTH_USER_USERNAME];
  [JNKeychain saveValue:email forKey: KEY_AUTH_USER_EMAIL];
  [JNKeychain saveValue:displayName forKey: KEY_AUTH_USER_DISPLAY_NAME];
  
  [self initAuthUser];
}

+ (void) savePinColour: (int) pinColour {
  
  [JNKeychain saveValue:[NSNumber numberWithInt:pinColour] forKey: KEY_AUTH_USER_PIN_COLOUR];
}

+ (BOOL) isLoggedIn {
  MapizToken *token = [MapizUser getToken];
  return [token.token length] > 0 && [token.tokenExpires laterDate:[NSDate date]];
}

+ (NSString *) getID {
  return [JNKeychain loadValueForKey:KEY_AUTH_USER_ID];
}

+ (MapizToken *) getToken {
  NSString *token = [JNKeychain loadValueForKey:KEY_AUTH_USER_TOKEN];
  NSDate *date = [JNKeychain loadValueForKey:KEY_AUTH_USER_TOKEN_EXPIRES];
  return [[MapizToken alloc] initWithToken:token expires:date];
}

+ (NSString *) getUsername {
  return [JNKeychain loadValueForKey:KEY_AUTH_USER_USERNAME];
}

+ (NSString *) getEmail {
  return [JNKeychain loadValueForKey:KEY_AUTH_USER_EMAIL];
}

+ (NSString *) getDisplayName {
  return [JNKeychain loadValueForKey:KEY_AUTH_USER_DISPLAY_NAME];
}

+ (int) getPinColour {
  
  int colour = [[JNKeychain loadValueForKey: KEY_AUTH_USER_PIN_COLOUR] intValue];
  return colour;
}

+ (MapizUser *) getAuthUserInstance {
  if(!loggedInUser) {
    [self initAuthUser];
  }
  return loggedInUser;
}

+ (void) initAuthUser {
  if([self isLoggedIn]) {
    loggedInUser = [[MapizUser alloc] init];
    loggedInUser._id = [self getID];
    loggedInUser.username = [self getUsername];
    loggedInUser.displayName = [self getDisplayName];
    loggedInUser.email = [self getEmail];
    loggedInUser.token = [self getToken];
  }
}

+ (void) clearAuthUser {
  [JNKeychain deleteValueForKey: KEY_AUTH_USER_TOKEN];
  [JNKeychain deleteValueForKey: KEY_AUTH_USER_TOKEN_EXPIRES];
  [JNKeychain deleteValueForKey: KEY_AUTH_USER_ID];
  [JNKeychain deleteValueForKey: KEY_AUTH_USER_USERNAME];
  [JNKeychain deleteValueForKey: KEY_AUTH_USER_EMAIL];
  [JNKeychain deleteValueForKey: KEY_AUTH_USER_DISPLAY_NAME];
  [JNKeychain deleteValueForKey: KEY_AUTH_USER_PIN_COLOUR];
  loggedInUser = nil;
}

@end
