//
//  MapizToken.h
//  Mapiz
//
//  Created by samuel on 10/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapizToken : NSObject
@property (nonatomic, retain) NSString* token;
@property (nonatomic, retain) NSDate* tokenExpires;

- (id) initWithToken: (NSString *) token
             expires: (NSDate *) expires;

@end
