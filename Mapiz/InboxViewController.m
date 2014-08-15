//
//  InboxViewController.m
//  Mapiz
//
//  Created by samuel on 08/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "InboxViewController.h"
#import "QuartzCore/QuartzCore.h"
#import <TTTTimeIntervalFormatter.h>

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
CLLocationManager *locationManager;

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
  timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
  [timeIntervalFormatter setUsesIdiomaticDeicticExpressions:YES];
  self.refreshControl = [[UIRefreshControl alloc]init];
  [self.refreshControl addTarget:self action:@selector(reloadInbox) forControlEvents:UIControlEventValueChanged];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.tableView addSubview:self.refreshControl];
  
  [self currentLocationIdentifier];
  
}

-(void)currentLocationIdentifier
{
  locationManager = [CLLocationManager new];
  locationManager.delegate = self;
  locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
  locationManager.headingFilter = kCLHeadingFilterNone;
  [locationManager startUpdatingHeading];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
  float azimuth = newHeading.magneticHeading;
  
}

- (void)reloadInbox {
  [MapizUser callMyInbox:^(NSDictionary *response, NSError *error) {
    items = [response objectForKey:@"result"];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
  }];
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
  
  MapizPin *pin = [[MapizPin alloc] initWithResponse: [items objectAtIndex:indexPath.row]];
  
  if (cell == nil) {
    cell = [[MapizPinTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
  }
  
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
      [cell.icon setText:@"\uf062"];
      double rads = (M_PI*-90)/180.0;
      [cell setTranslatesAutoresizingMaskIntoConstraints:YES];
      CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, rads);
      cell.icon.transform = transform;
      
    } else if([pin isWhereAreYouType]) {
      [cell.icon setText:@"\uf128"];
    }
  } else {
    [cell.username setText:pin.recipient.username];
    if([pin isWhereAreYouType]) {
      if([pin hasReply]) {
        [cell.icon setText:@"\uf00c"];
      } else {
        [cell.icon setText:@"\uf141"];
      }
    } else if([pin isImHereType]) {
      [cell.icon setText:@"\uf00c"];
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
    
    if([pin isRecipient]) {
      if([pin hasReply]) {
        
      } else {
        [cell.subIcon setText:@"\uf128"];
      }
    } else {
      if([pin hasReply]) {
        if(pin.recipientIsGoing) {
          [cell.subIcon setText:@"\uf00c"];
        } else {
          [cell.subIcon setText:@"\uf00d"];
        }
      } else {
        [cell.subIcon setText:@"\uf141"];
      }
    }
    
  } else {
    [cell.subIcon setHidden:YES];
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
  MapizPin *pin = [[MapizPin alloc] initWithResponse: [items objectAtIndex:indexPath.row]];
  if([pin isWhereAreYouType] && [pin isRecipient] && ![pin hasReply]) {
    [self.mapizViewController setModeReplyTo:pin];
  }
}

- (void)didReceiveAuthUserDetails:(MapizUser *)user {
  
}

- (void)didConnect {
  
}

- (void)didAuth {
  [MapizUser callMyInbox:^(NSDictionary *response, NSError *error) {
    items = [response objectForKey:@"result"];
    [self.tableView reloadData];
  }];
}

@end
