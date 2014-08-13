//
//  MapizDDPClient.h
//  Mapiz
//
//  Created by samuel on 11/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <ObjectiveDDP/MeteorClient+Private.h>
#import "MapizUser.h"

@class MapizUser;

@protocol MapizDDPDelegate;

@interface MapizDDPClient : MeteorClient

@property (nonatomic, weak) id <MapizDDPDelegate> delegate;

- (void)logonWithToken:(NSString *)token responseCallback:(MeteorClientMethodCallback)responseCallback;

+(MapizDDPClient *) getInstance;
@end

@protocol MapizDDPDelegate

- (void)didConnect;
- (void)didAuth;
- (void)didReceiveAuthUserDetails:(MapizUser *)user;

@end