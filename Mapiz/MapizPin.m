//
//  MapizPin.m
//  Mapiz
//
//  Created by samuel on 09/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizPin.h"

@implementation MapizPin

+(NSString*) pinImage:(int)colour {
  switch (colour) {
    case PinColourGreen:
      return @"ic_marker_green.png";
    case PinColourPurple:
      return @"ic_marker_purple.png";
    case PinColourOrange:
      return @"ic_marker_orange.png";
    case PinColourBlack:
      return @"ic_marker_black.png";
    case PinColourRed:
      return @"ic_marker_red.png";
    case PinColourYellow:
      return @"ic_marker_yellow.png";
  }
  return @"ic_marker_blue.png";
}
  
@end
