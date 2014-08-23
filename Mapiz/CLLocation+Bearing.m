//
//  CLLocation+Bearing.m
//  Mapiz
//
//  Created by samuel on 17/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "CLLocation+Bearing.h"


@implementation CLLocation (Bearing)

CGFloat DegreesToRadians(CGFloat degrees) {
  return degrees * M_PI / 180;
}

CGFloat RadiansToDegrees(CGFloat radians) {
  return radians * 180 / M_PI;
}

- (double)bearingToLocation:(CLLocation *)location {
  double lat1 = DegreesToRadians(self.coordinate.latitude);
  double lng1 = DegreesToRadians(self.coordinate.longitude);
  double lat2 = DegreesToRadians(location.coordinate.latitude);
  double lng2 = DegreesToRadians(location.coordinate.longitude);
  double deltalng = lng2 - lng1;
  double y = sin(deltalng) * cos(lat2);
  double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltalng);
  double bearing = atan2(y, x) + 2 * M_PI;
  double bearingDegrees = RadiansToDegrees(bearing);
  bearingDegrees = (int)bearingDegrees % 360;
  return bearingDegrees;
}
@end