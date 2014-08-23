//
//  MapizDDPClient.m
//  Mapiz
//
//  Created by samuel on 11/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizDDPClient.h"

@implementation MapizDDPClient

@synthesize delegate;

static MapizDDPClient* instance;

BOOL REQUEST_RESUME_PENDING = NO;

- (id)init {
  self = [super initWithDDPVersion:@"pre2"];

//  ObjectiveDDP *ddp = [[ObjectiveDDP alloc] initWithURLString:@"wss://mapiz.herokuapp.com/websocket" delegate:self];
  ObjectiveDDP *ddp = [[ObjectiveDDP alloc] initWithURLString:@"ws://192.168.1.65:3000/websocket" delegate:self];
  self.ddp = ddp;
  [self.ddp connectWebSocket];
  
  return self;
}

-(void)logonWithToken:(NSString *)token responseCallback:(MeteorClientMethodCallback)responseCallback {
  [self logonWithUserParameters:[self _buildParametersWithToken:token] responseCallback:responseCallback];
}

+ (MapizDDPClient *) getInstance {
  if(!instance) {
    instance = [[MapizDDPClient alloc] init];
  }
  return instance;
}

- (void)didReceiveMessage:(NSDictionary *)message {
  [super didReceiveMessage:message];
  NSString *msg = [message objectForKey:@"msg"];
  
  if([msg isEqualToString:@"connected"]) {
    REQUEST_RESUME_PENDING = YES;
    [self.delegate didConnect];
    if([MapizUser isLoggedIn]) {
      [self logonWithToken:[MapizUser getToken].token responseCallback:^(NSDictionary *response, NSError *error) {
        if(!error) {
          [self.delegate didAuth];
        }
      }];
    }
  }
  
  if([MapizUser isLoggedIn]) {
    if([msg isEqualToString:@"added"]) {
      NSString *_id = [message objectForKey:@"id"];
      NSString *collection = [message objectForKey:@"collection"];
      if([collection isEqualToString:@"users"] && [_id isEqualToString:[MapizUser getID]]) {
        NSDictionary *fields = [message objectForKey:@"fields"];
        NSString *username = [fields objectForKey:@"username"];
        NSString *displayName = [fields valueForKeyPath:@"profile.display_name"];
        NSArray *emails = [fields valueForKey:@"emails"];
        
        NSString *email = [[emails objectAtIndex:0] objectForKey:@"address"];
        
        [MapizUser saveAuthUserProfileWithUsername:username email:email displayName:displayName];
        
        [self.delegate didReceiveAuthUserDetails:[MapizUser getAuthUserInstance]];
        
      }
    }
  }
}

- (NSDictionary *)_buildParametersWithToken:(NSString *)token {
  return @{ @"resume": token };
}

@end
