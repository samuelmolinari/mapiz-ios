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
@synthesize mapizViewController;
@synthesize submitButton;
@synthesize pinLabel;
@synthesize dateLabel;

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
  
  pinColour = [MapizUser getPinColour];
  [self updatePinColour];
  pinLabel.text = [[[MapizUser getUsername] substringToIndex:1] uppercaseString];
  self.mapView.delegate = self;
  [self startTracking];
  [submitButton setTitle:@"  " forState:UIControlStateDisabled];
  [dateLabel sizeToFit];
}

- (IBAction)submit:(id)sender {
  CLLocation *location = [[CLLocation alloc] initWithLatitude:mapView.region.center.latitude longitude:mapView.region.center.longitude];
  if(![mapizViewController isInModeReplyTo]) {
    if([dateLabel isHidden]) {
      [mapizViewController setModeImHere: location];
    } else {
      [mapizViewController setModeMeetMeThere:location];
    }
    [submitButton setHidden: YES];
    [dateLabel setHidden: YES];
  } else {
    NSDate *date;
    int pinType;
    if([dateLabel isHidden]) {
      pinType = PinTypeImHere;
      date = [[NSDate alloc] init];
    } else {
      pinType = PinTypeMeetMeThere;
      date = mapizViewController.locationSavedAt;
    }
    
    [submitButton setEnabled:NO];
    [_actionInProgressIndicator setHidden:NO];
    [MapizPin callSubmitPinOfType:pinType
                     toRecipients:@[mapizViewController.replyTo.sender._id]
                  withCoordinates:location
                               at:date
                 responseCallback:^(NSDictionary *response, NSError *error) {
                                 [submitButton setEnabled:YES];
                                 [_actionInProgressIndicator setHidden:YES];
                                 [mapizViewController cancelMode];
                               }];
  }
  [self stopTracking];
  [self.mapizViewController lockMap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changePinColor:(id)sender {
  pinColour = (pinColour + 1) % 7;
  [self updatePinColour];
}

- (void) updatePinColour {
  UIImage *uiImage = [UIImage imageNamed: [MapizPin pinImage: pinColour]];
  [pinButton setImage: uiImage forState: UIControlStateNormal];
  [MapizUser savePinColour:pinColour];
}

- (void)startTracking {
  trackingUser = YES;
  [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:NO];
  CLLocation *location = [[CLLocation alloc] initWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude];
  [self.mapizViewController updateMyLocation:location];
  [self.mapView setShowsUserLocation: YES];
  [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (void)stopTracking {
  [self performSelector:@selector(stopTrackingNow) withObject:nil afterDelay:30.0];
}

- (void)stopTrackingNow {
  [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone animated:NO];
    [self.mapView setShowsUserLocation: NO];
    trackingUser = NO;
  }];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  
  CLLocation *location = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
  [self.mapizViewController updateMyLocation:location];
  [self stopTracking];
}

-(BOOL)isTracking {
  return trackingUser;
}

- (IBAction)removeMeetup:(id)sender {
  [self.mapizViewController.datePicker setDate:[[NSDate alloc] init]];
  [self.dateLabel setTitle:@"" forState:UIControlStateNormal];
  [self.dateLabel setHidden:YES];
  [self.submitButton setTitle:@"I'm here!" forState:UIControlStateNormal];
}

-(void)lockMap {
  [mapView setZoomEnabled: NO];
  [mapView setScrollEnabled: NO];
  [mapView setUserInteractionEnabled: NO];
}

-(void)unlockMap {
  [self stopTrackingNow];
  [mapView setZoomEnabled: YES];
  [mapView setScrollEnabled: YES];
  [mapView setUserInteractionEnabled: YES];
}

- (void)didReceiveAuthUserDetails:(MapizUser *)user {
  pinLabel.text = [[user.username substringToIndex:1] uppercaseString];
}

- (void)didAuth {
  
}

@end
