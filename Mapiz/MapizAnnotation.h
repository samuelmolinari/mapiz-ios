//
//  MapizAnnotation.h
//  Mapiz
//
//  Created by samuel on 15/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MapizPin.h"

@interface MapizAnnotation : NSObject<MKAnnotation> {
  MapizPin* pin;
  CLLocationCoordinate2D coordinate;
}

@property (nonatomic, retain) MapizPin* pin;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithPin:(MapizPin *)pin;
- (MKAnnotationView *) annotationView;

@end
