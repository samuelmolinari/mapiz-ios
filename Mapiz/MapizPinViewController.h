//
//  MapizPinViewController.h
//  Mapiz
//
//  Created by samuel on 15/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapizPin.h"
#import "MapizAnnotation.h"

@interface MapizPinViewController : UIViewController<MKMapViewDelegate> {
  IBOutlet MKMapView *mapView;
  IBOutlet UIView *statusBar;
  IBOutlet UINavigationBar *navigationBar;
  IBOutlet UILabel *day;
  IBOutlet UILabel *month;
  IBOutlet UILabel *year;
  IBOutlet UILabel *time;
  IBOutlet UILabel *senderUsername;
  IBOutlet UIButton *acceptButton;
  IBOutlet UIButton *declineButton;
  IBOutlet UIView *meetupDetails;
  IBOutlet NSLayoutConstraint *mapBottomAlign;
  IBOutlet UIActivityIndicatorView *actionInProgressIndicator;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIView *statusBar;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UILabel *day;
@property (nonatomic, retain) IBOutlet UILabel *month;
@property (nonatomic, retain) IBOutlet UILabel *year;
@property (nonatomic, retain) IBOutlet UILabel *time;
@property (nonatomic, retain) IBOutlet UILabel *senderUsername;
@property (nonatomic, retain) IBOutlet UIButton *acceptButton;
@property (nonatomic, retain) IBOutlet UIButton *declineButton;
@property (nonatomic, retain) IBOutlet UIView *meetupDetails;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *mapBottomAlign;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *actionInProgressIndicator;
@property (nonatomic, retain) MapizPin *pin;

@end
