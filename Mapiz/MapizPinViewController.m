//
//  MapizPinViewController.m
//  Mapiz
//
//  Created by samuel on 15/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizPinViewController.h"
#import "MapizPinView.h"

@implementation MapizPinViewController

@synthesize pin;
@synthesize acceptButton;
@synthesize declineButton;

UIColor *color;
CLLocationDegrees *minLat;
CLLocationDegrees *minLng;
CLLocationDegrees *maxLat;
CLLocationDegrees *maxLng;
MKAnnotationView *annotationView;
CLLocation *targetLocation;

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
  
  if([pin isWhereAreYouType] && [pin isSender] && [pin hasReply]) {
    targetLocation = pin.recipientLocation;
  } else {
    targetLocation = pin.senderLocation;
  }
  
  color = [MapizPin pinColour:pin.colour];
  [_statusBar setBackgroundColor:color];
  [_navigationBar setBarTintColor:color];
  [_meetupDetails setBackgroundColor:color];
  
  self.mapView.delegate = self;
  
  MapizAnnotation* annotation = [[MapizAnnotation alloc] initWithPin:pin];
  
  [self.mapView addAnnotation:annotation];
  
  [self.mapView setCenterCoordinate:targetLocation.coordinate animated:YES];
  [self.mapView setShowsUserLocation: YES];
  [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
  
  if(pin.isMeetup) {
    if(!pin.hasReply && pin.isRecipient) {
      acceptButton.hidden = NO;
      declineButton.hidden = NO;
    } else {
      acceptButton.hidden = YES;
      declineButton.hidden = YES;
    }
    
    _meetupDetails.hidden = NO;
    if(pin.isRecipient) {
      _senderUsername.text = pin.sender.username;
    } else {
      _senderUsername.text = pin.recipient.username;
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"dd"];
    _day.text = [formatter stringFromDate:pin.senderHereAt];
    
    [formatter setDateFormat:@"MMM"];
    _month.text = [[formatter stringFromDate:pin.senderHereAt] uppercaseString];
    
    [formatter setDateFormat:@"YYYY"];
    _year.text = [formatter stringFromDate:pin.senderHereAt];
    
    [formatter setDateFormat:@"HH:mm"];
    _time.text = [formatter stringFromDate:pin.senderHereAt];
    
    
  } else {
    acceptButton.hidden = YES;
    declineButton.hidden = YES;
    _meetupDetails.hidden = YES;
    _mapBottomAlign.constant = 0;
  }
}

- (IBAction)goBack:(id)sender {
  [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  CLLocation *location = [[CLLocation alloc] initWithLatitude:mapView.region.center.latitude longitude:mapView.region.center.longitude];
  
  double minLat = fmin(userLocation.coordinate.latitude, targetLocation.coordinate.latitude);
  double maxLat = fmax(userLocation.coordinate.latitude, targetLocation.coordinate.latitude);
  double minLng = fmin(userLocation.coordinate.longitude, targetLocation.coordinate.longitude);
  double maxLng = fmax(userLocation.coordinate.longitude, targetLocation.coordinate.longitude);
  
  MKCoordinateRegion region;
  region.center.latitude = (minLat + maxLat) / 2;
  region.center.longitude = (minLng + maxLng) / 2;
  
  region.span.latitudeDelta = (maxLat - minLat) * 1.5;
  
  region.span.latitudeDelta = (region.span.latitudeDelta < 0.01)
  ? 0.01
  : region.span.latitudeDelta;
  
  region.span.longitudeDelta = (maxLng - minLng) * 1.5;
  
  MKCoordinateRegion scaledRegion = [mapView regionThatFits:region];
  [mapView setRegion:scaledRegion animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  if([annotation isKindOfClass: [MapizAnnotation class]]) {
    MapizAnnotation *annot = (MapizAnnotation *) annotation;
    annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"MapizAnnotation"];
    if(annotationView == nil) {
      annotationView = annot.annotationView;
    } else {
      annotationView.annotation = annotation;
    }
    return annotationView;
  }
  
  return nil;
}

- (IBAction)acceptMeetup:(id)sender {
  [acceptButton setEnabled:NO];
  [declineButton setEnabled:NO];
  [_actionInProgressIndicator setHidden:NO];
  [MapizPin callAcceptMeetupInvite:pin._id responseCallback:^(NSDictionary *response, NSError *error) {
    [_actionInProgressIndicator setHidden:YES];
    if(error) {
      [acceptButton setEnabled:YES];
      [declineButton setEnabled:YES];
    } else {
      [acceptButton setHidden:YES];
      [declineButton setHidden:YES];
      MapizPinView *pinView = [[annotationView subviews] objectAtIndex:0];
      pinView.pinLabel.text = @"\uf00c";
    }
  }];
}

- (IBAction)declineMeetup:(id)sender {
  [acceptButton setEnabled:NO];
  [declineButton setEnabled:NO];
  [_actionInProgressIndicator setHidden:NO];
  [MapizPin callTurnDownMeetupInvite:pin._id responseCallback:^(NSDictionary *response, NSError *error) {
    [_actionInProgressIndicator setHidden:YES];
    if(error) {
      [acceptButton setEnabled:YES];
      [declineButton setEnabled:YES];
    } else {
      [acceptButton setHidden:YES];
      [declineButton setHidden:YES];
      MapizPinView *pinView = [[annotationView subviews] objectAtIndex:0];
      pinView.pinLabel.text = @"\uf00d";
    }
  }];
}

- (IBAction)getDirections:(id)sender {
  NSURL *testURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
  NSURL *directionsURL;
  NSString *coordinates = [NSString stringWithFormat:@"%f,%f", targetLocation.coordinate.latitude, targetLocation.coordinate.longitude];
  if ([[UIApplication sharedApplication] canOpenURL:testURL]) {
    NSString *directionsRequest = [NSString stringWithFormat:@"comgooglemaps-x-callback://?daddr=%@&directionsmode=transit&x-success=sourceapp://?resume=true&x-source=co.mapiz.Mapiz", coordinates];
    directionsURL = [NSURL URLWithString:directionsRequest];
  } else {
    directionsURL = [NSURL URLWithString:[NSString stringWithFormat: @"http://maps.apple.com/maps?saddr=Current+Location&daddr=%@&mode=transit", coordinates]];
  }
  
  [[UIApplication sharedApplication] openURL:directionsURL];
}

@end
