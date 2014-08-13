//
//  MapizUser.h
//  Mapiz
//
//  Created by samuel on 10/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapizToken.h"
#import "MapizDDPClient.h"

@interface MapizUser : NSObject

extern NSString * const USERS_COLLECTION_NAME;

@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) MapizToken *token;

- (id)initWithResponse: (NSDictionary *) dictionary;

+ (void) saveAuthUserWithToken: (NSString *) token
                       expires: (NSDate *) expires
                           _id: (NSString *) _id
                      username: (NSString *) username
                         email: (NSString *) email
                   displayName: (NSString *) displayName;

+ (void) saveAuthUserProfileWithUsername: (NSString *) username
                                   email: (NSString *) email
                             displayName: (NSString *) displayName;
+ (void) savePinColour: (int) pinColour;
+ (BOOL) isLoggedIn;
+ (NSString *) getID;
+ (MapizToken *) getToken;
+ (NSString *) getUsername;
+ (NSString *) getEmail;
+ (NSString *) getDisplayName;
+ (int) getPinColour;
+ (MapizUser *) getAuthUserInstance;
+ (void) clearAuthUser;
+ (void) callMyFriends: (MeteorClientMethodCallback) responseCallback;
+ (void) callAddFriend: (NSString *) username responseCallback:(MeteorClientMethodCallback) responseCallback;
+ (void) callMyInbox: (MeteorClientMethodCallback) responseCallback;

@end
