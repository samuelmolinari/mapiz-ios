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
+ (void) setUsername: (NSString *) username;
+ (void) setEmail: (NSString *) email;
+ (void) setDisplayName: (NSString *) displayName;
+ (int) getPinColour;
+ (void) saveApnToken: (NSString *) token;
+ (NSString *) getApnToken;
+ (MapizUser *) getAuthUserInstance;
+ (void) clearAuthUser;
+ (void) callMyFriends: (MeteorClientMethodCallback) responseCallback;
+ (void) callAddFriend: (NSString *) username responseCallback:(MeteorClientMethodCallback) responseCallback;
+ (void) callMyInbox: (MeteorClientMethodCallback) responseCallback;
+ (void) callUpdateUsername: (NSString *) username responseCallback: (MeteorClientMethodCallback) responseCallback;
+ (void) callUpdateEmail: (NSString *) email responseCallback: (MeteorClientMethodCallback) responseCallback;
+ (void) callUpdateDisplayName: (NSString *) displayName responseCallback: (MeteorClientMethodCallback) responseCallback;
+ (void) callChangePassword: (NSString *) oldPassword withNewPassword: (NSString *) newPassword responseCallback: (MeteorClientMethodCallback) responseCallback;
+ (void) callAddApnToken: (NSString *) apnToken responseCallback: (MeteorClientMethodCallback) responseCallback;
+ (void) callRemoveApnToken: (NSString *) apnToken responseCallback: (MeteorClientMethodCallback) responseCallback;
@end
