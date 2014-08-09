//
//  MapViewController.h
//  Mapiz
//
//  Created by samuel on 08/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapizViewController.h"

@class MapizViewController;
@class MapizPrimaryImportantButton;

@interface MapViewController : UIViewController<MKMapViewDelegate> {
  IBOutlet MKMapView *mapView;
  IBOutlet UIButton *pinButton;
  IBOutlet UIButton *submitButton;
}

@property (nonatomic, retain) IBOutlet MKMapView* mapView;
@property (nonatomic, retain) IBOutlet UIButton* pinButton;
@property (nonatomic, retain) IBOutlet UIButton* submitButton;
@property (nonatomic, weak) MapizViewController* mapizViewController;

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation;

- (void)startTracking;

- (void)stopTracking;

- (BOOL)isTracking;

- (void)lockMap;

- (void)unlockMap;

- (MapizViewController*) getMapizViewController;

@end
