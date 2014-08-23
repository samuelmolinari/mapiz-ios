//
//  InboxViewController.m
//  Mapiz
//
//  Created by samuel on 08/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "InboxViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "CLLocation+Bearing.h"
#import <TTTTimeIntervalFormatter.h>
#import <TTTLocationFormatter.h>

@interface InboxViewController ()

@end

@implementation InboxViewController
@synthesize tableView;
@synthesize refreshControl;
@synthesize mapizViewController;

int pageLoaded = 0;
int bulkSize = 50;
int loadNextPageBeforeLast = 10;

NSMutableArray * items;
TTTTimeIntervalFormatter *timeIntervalFormatter;
TTTLocationFormatter *locationFormatter;
CLLocationManager *locationManager;
CLLocation *myLocation;
double arrowAnimationTimestamp;
int itemIndexToBeRemoved;
BOOL isLoadingInbox;

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
  isLoadingInbox = NO;
  
  UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
  [self.tableView addGestureRecognizer:longPressRecognizer];
  
  arrowAnimationTimestamp = CACurrentMediaTime();
  
  timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
  [timeIntervalFormatter setUsesIdiomaticDeicticExpressions:YES];
  
  locationFormatter = [[TTTLocationFormatter alloc] init];
  [locationFormatter setUnitSystem:TTTMetricSystem];
  
  self.refreshControl = [[UIRefreshControl alloc]init];
  [self.refreshControl addTarget:self action:@selector(reloadInbox) forControlEvents:UIControlEventValueChanged];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.tableView addSubview:self.refreshControl];
  [refreshControl beginRefreshing];
  [self currentLocationIdentifier];
  
}

-(void) onLongPress:(UILongPressGestureRecognizer*)pGesture {
  if (pGesture.state == UIGestureRecognizerStateBegan) {
    CGPoint touchPoint = [pGesture locationInView:tableView];
    NSIndexPath* row = [tableView indexPathForRowAtPoint:touchPoint];
    
    if (row != nil) {
      itemIndexToBeRemoved = row.row;
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete pin"
                                                      message:@"Are you sure?"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Delete", nil];
      
      [alert show];
    }
  }
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex != 0) {
    int index = itemIndexToBeRemoved;
    MapizPin *pin = [[MapizPin alloc] initWithResponse:[items objectAtIndex:index]];
    [MapizPin callRemove:pin._id responseCallback:^(NSDictionary *response, NSError *error) {
      [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        if(error) {
        
        } else {
          NSMutableArray *copy = [items mutableCopy];
          [copy removeObjectAtIndex:index];
          items = copy;
          [tableView reloadData];
        }
      }];
    }];
  }
}

-(void)currentLocationIdentifier
{
  locationManager = [CLLocationManager new];
  locationManager.delegate = self;
  locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
  locationManager.headingFilter = kCLHeadingFilterNone;
  [locationManager startUpdatingHeading];
//  [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
  if (mapizViewController.position == 0 && CACurrentMediaTime() - arrowAnimationTimestamp > 0.1) {
    arrowAnimationTimestamp = CACurrentMediaTime();
    float azimuth = newHeading.magneticHeading;
    NSArray *visibleCells = [tableView visibleCells];
    for(MapizPinTableViewCell *cell in visibleCells) {
      if(cell.location != NULL) {
        double rads = (M_PI*([myLocation bearingToLocation: cell.location] - azimuth))/180.0;
        CGAffineTransform arrowTransform = CGAffineTransformRotate(CGAffineTransformIdentity, rads);
        cell.icon.transform = arrowTransform;
        cell.distance.text = [locationFormatter stringFromDistanceFromLocation:myLocation toLocation:cell.location];
        [cell.distance setHidden:NO];
      }
    }
  }
  
}

- (void)reloadInbox {
  if(!isLoadingInbox) {
    isLoadingInbox = YES;
    [MapizUser callMyInbox:^(NSDictionary *response, NSError *error) {
      items = [response objectForKey:@"result"];
      [self.tableView reloadData];
      [self.refreshControl endRefreshing];
      isLoadingInbox = NO;
    }];
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *MyIdentifier = @"pinCell";
  MapizPinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
//  [cell.icon setTranslatesAutoresizingMaskIntoConstraints:YES];
  CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);
  [cell.distance setHidden:YES];
  MapizPin *pin = [[MapizPin alloc] initWithResponse: [items objectAtIndex:indexPath.row]];
  
  if (cell == nil) {
    cell = [[MapizPinTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
  }
  
  cell.location = NULL;
  
  UIColor *colour = [MapizPin pinColour:pin.colour];
  
  if([pin isWhereAreYouType] && ![pin hasReply]) {
    colour = [UIColor secondayDark];
  }
  
  [cell setSquareColour: colour];
  [cell.icon setFont: [UIFont fontWithName:@"FontAwesome" size:20]];
  [cell.username sizeToFit];
  
  cell.subIcon.layer.cornerRadius = cell.subIcon.bounds.size.width/2.0;
  
  if([pin isRecipient]) {
    [cell.username setText:pin.sender.username];
    if([pin isImHereType]) {
      cell.location = pin.senderLocation;
      [cell.icon setText:@"\uf062"];
      [cell.distance setText:[locationFormatter stringFromDistanceFromLocation:myLocation toLocation:pin.senderLocation]];
      [cell.distance setHidden:NO];
      [cell.caption setText:@"has shared their location with you"];
      
    } else if([pin isWhereAreYouType]) {
      [cell.icon setText:@"\uf128"];
      [cell.caption setText:@"would like to know where you are"];
    }
  } else {
    [cell.username setText:pin.recipient.username];
    if([pin isWhereAreYouType]) {
      if([pin hasReply]) {
        [cell.icon setText:@"\uf00c"];
        cell.location = pin.recipientLocation;
        [cell.icon setText:@"\uf062"];
        [cell.distance setText:[locationFormatter stringFromDistanceFromLocation:myLocation toLocation:pin.recipientLocation]];
        [cell.distance setHidden:NO];
        [cell.caption setText:@"has shared their location with you"];

      } else {
        [cell.icon setText:@"\uf141"];
        [cell.caption setText:@"has not responded yet"];
      }
    } else if([pin isImHereType]) {
      [cell.icon setText:@"\uf00c"];
      [cell.caption setText:@"has received your location"];
    }
    
  }
  
  [cell.createdAt setText:[timeIntervalFormatter
    stringForTimeInterval:[pin.updatedAt timeIntervalSinceDate:[[NSDate alloc] init]]
  ]];
  
  if([pin isMeetup]) {
    [cell.icon setText:@"\uf073"];
    [cell.subIcon setFont: [UIFont fontWithName:@"FontAwesome" size:8]];
    
    [cell.subIcon setTextColor:colour];
    [cell.subIcon setHidden:NO];
    
    NSString *time = [timeIntervalFormatter
                      stringForTimeInterval:[pin.senderHereAt timeIntervalSinceDate:[[NSDate alloc] init]]
                      ];
    
    if([pin hasReply]) {
      if(pin.recipientIsGoing) {
        [cell.subIcon setText:@"\uf00c"];
        [cell.caption setText:[NSString stringWithFormat:@"is meeting you %@", time]];
      } else {
        [cell.subIcon setText:@"\uf00d"];
        [cell.caption setText:@"Meetup has been cancelled"];
      }
    } else {
      if([pin isRecipient]) {
        [cell.subIcon setText:@"\uf128"];
        [cell.caption setText:[NSString stringWithFormat:@"would like to meet %@", time]];
        
      } else {
        [cell.subIcon setText:@"\uf141"];
        [cell.caption setText:@"has not responded yet"];
      }
    }
    
  } else {
    [cell.subIcon setHidden:YES];
  }
  
  cell.icon.transform = transform;

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
  MapizPin *pin = [[MapizPin alloc] initWithResponse: [items objectAtIndex:indexPath.row]];
  if([pin isWhereAreYouType] && [pin isRecipient] && ![pin hasReply]) {
    [self.mapizViewController setModeReplyTo:pin];
  } else if([pin isImHereType] || [pin isMeetup] || ([pin isWhereAreYouType] && [pin isSender] && [pin hasReply])) {
    MapizPinViewController *pinViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapizPinViewController"];
    pinViewController.pin = pin;
    [self.mapizViewController presentViewController:pinViewController animated:YES completion:nil];
  }
}

- (void)updateMyLocation:(CLLocation *)location {
  myLocation = location;
  
  for(NSIndexPath *indexPath in tableView.indexPathsForVisibleRows) {
    MapizPin *pin = [[MapizPin alloc] initWithResponse: [items objectAtIndex:indexPath.row]];
    if([pin isRecipient] && [pin isImHereType]) {
      [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
    }
  }
}

- (void)didReceiveAuthUserDetails:(MapizUser *)user {
  
}

- (void)didConnect {
  
}

- (void)didAuth {
  [self reloadInbox];
  [[MapizDDPClient getInstance] addSubscription:@"inbox"];
}

@end
