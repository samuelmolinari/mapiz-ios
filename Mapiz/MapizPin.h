//
//  MapizPin.h
//  Mapiz
//
//  Created by samuel on 09/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapizPin : NSObject

typedef NS_ENUM(NSInteger, Colour) {
  PinColourBlue = 0,
  PinColourPurple = 1,
  PinColourOrange = 2,
  PinColourRed = 3,
  PinColourGreen = 4,
  PinColourYellow = 5,
  PinColourBlack = 6
};

+ (NSString *)pinImage: (int)colour;

@end
