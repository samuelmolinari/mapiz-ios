#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CLLocation (Bearing)

- (double)bearingToLocation:(CLLocation *)location;

@end