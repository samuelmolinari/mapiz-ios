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

@interface MapViewController : UIViewController<MKMapViewDelegate, MapizDDPDelegate> {
  IBOutlet MKMapView *mapView;
  IBOutlet UIButton *pinButton;
  IBOutlet UIButton *submitButton;
  IBOutlet UILabel *pinLabel;
  IBOutlet UIButton *dateLabel;
  IBOutlet UIActivityIndicatorView *actionInProgressIndicator;
}

@property (nonatomic, retain) IBOutlet MKMapView* mapView;
@property (nonatomic, retain) IBOutlet UIButton* pinButton;
@property (nonatomic, retain) IBOutlet UIButton* submitButton;
@property (nonatomic, retain) IBOutlet UILabel* pinLabel;
@property (nonatomic, retain) IBOutlet UIButton* dateLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *actionInProgressIndicator;
@property (nonatomic, weak) MapizViewController* mapizViewController;

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation;

- (void)startTracking;

- (void)stopTracking;

- (void)stopTrackingNow;

- (BOOL)isTracking;

- (void)lockMap;

- (void)unlockMap;

- (MapizViewController*) getMapizViewController;

- (void)didReceiveAuthUserDetails:(MapizUser *)user;
- (void)didConnect;
- (void)didAuth;

@end
