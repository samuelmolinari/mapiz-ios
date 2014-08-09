//
//  MapViewController.m
//  Mapiz
//
//  Created by samuel on 08/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapViewController.h"
#import "MapizPin.h"

@implementation MapViewController
@synthesize mapView;
@synthesize pinButton;

BOOL trackingUser = NO;
int pinColour;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  pinColour = PinColourBlue;
  self.mapView.delegate = self;
  [self startTracking];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changePinColor:(id)sender {
  pinColour = (pinColour + 1) % 7;
  UIImage *uiImage = [UIImage imageNamed: [MapizPin pinImage: pinColour]];
  [pinButton setImage: uiImage forState: UIControlStateNormal];
}

- (void)startTracking {
  trackingUser = YES;
  [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:NO];
  [self.mapView setShowsUserLocation: YES];
  [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
}

- (void)stopTracking {
  [NSThread sleepForTimeInterval:3];
  [self.mapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
  [self.mapView setShowsUserLocation: NO];
  trackingUser = NO;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  [self performSelectorInBackground:@selector(stopTracking) withObject:nil];
}

-(BOOL)isTracking {
  return trackingUser;
}

@end
