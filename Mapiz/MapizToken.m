//
//  MapizToken.m
//  Mapiz
//
//  Created by samuel on 10/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizToken.h"

@implementation MapizToken
@synthesize token;
@synthesize tokenExpires;

-(id) initWithToken:(NSString *)token expires:(NSDate *)expires {
  self = [super init];
  if (self) {
    self.token = token;
    self.tokenExpires = expires;
  }
  return self;
}

@end
