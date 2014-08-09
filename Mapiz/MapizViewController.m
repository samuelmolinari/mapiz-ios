//
//  MapizViewController.m
//  Mapiz
//
//  Created by samuel on 07/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizViewController.h"
#import "MapViewController.h"
#import "InboxViewController.h"
#import "FriendsViewController.h"

@interface MapizViewController ()

@end

@implementation MapizViewController;

@synthesize mapViewController;
@synthesize inboxViewController;
@synthesize friendsViewController;

@synthesize scrollView;
@synthesize leftNavButton;
@synthesize rightNavButton;
@synthesize lockUnlockButton;
@synthesize findMeButton;
@synthesize meetupButton;
@synthesize tabsView;

int const MODE_IM_HERE = 0;

int const TOTAL_SECTIONS = 3;
int const INDEX_SECTION_INBOX = 0;
int const INDEX_SECTION_MAP = 1;
int const INDEX_SECTION_FRIENDS = 2;

int mode;
int position;

CGRect tabFrame;

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.scrollView.delegate = self;
  
  self.inboxViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InboxViewController"];
  self.mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
  self.friendsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsViewController"];
  
  [lockUnlockButton.titleLabel setFont: [UIFont fontWithName:@"FontAwesome" size:20]];
  [lockUnlockButton setTitle:@"\uf023" forState:UIControlStateNormal];
  
  [findMeButton.titleLabel setFont: [UIFont fontWithName:@"FontAwesome" size:20]];
  [findMeButton setTitle:@"\uf05b" forState:UIControlStateNormal];
  
  [meetupButton.titleLabel setFont: [UIFont fontWithName:@"FontAwesome" size:20]];
  [meetupButton setTitle:@"\uf073" forState:UIControlStateNormal];
}

-(void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * TOTAL_SECTIONS, self.scrollView.frame.size.height);
  
  CGSize size = self.scrollView.layer.frame.size;
  
  CGRect mapFrame;
  mapFrame.size = size;
  mapFrame.origin.x = size.width * INDEX_SECTION_MAP;
  mapFrame.origin.y = 0;

  CGRect inboxFrame;
  inboxFrame.size = size;
  inboxFrame.origin.x = size.width * INDEX_SECTION_INBOX;
  inboxFrame.origin.y = 0;
  
  CGRect friendsFrame;
  inboxFrame.size = size;
  inboxFrame.origin.x = size.width * INDEX_SECTION_FRIENDS;
  inboxFrame.origin.y = 0;
  
  self.inboxViewController.view.frame = inboxFrame;
  self.mapViewController.view.frame = mapFrame;
  self.friendsViewController.view.frame = friendsFrame;
  
  [self.scrollView addSubview: self.mapViewController.view];
  [self.scrollView addSubview: self.inboxViewController.view];
  [self.scrollView addSubview: self.friendsViewController.view];
  
  tabFrame = tabsView.frame;
  
  [self moveToPosition: INDEX_SECTION_MAP];
  
  [self.view layoutIfNeeded];
}

- (IBAction)goToRight:(id)sender {
  switch(position) {
    case INDEX_SECTION_MAP:
      [self moveToPosition:INDEX_SECTION_FRIENDS];
      break;
    case INDEX_SECTION_INBOX:
      [self moveToPosition:INDEX_SECTION_MAP];
      break;
    case INDEX_SECTION_FRIENDS:
//      [self moveToPosition:INDEX_SECTION_MAP];
      break;
  }
}

- (IBAction)goToLeft:(id)sender {
  switch(position) {
    case INDEX_SECTION_MAP:
      [self moveToPosition:INDEX_SECTION_INBOX];
      break;
    case INDEX_SECTION_INBOX:
      break;
    case INDEX_SECTION_FRIENDS:
      [self moveToPosition:INDEX_SECTION_MAP];
      break;
  }
  
}

- (void)moveToPosition: (int)i {
  CGRect frame;
  frame.origin.x = self.scrollView.frame.size.width * i;
  frame.origin.y = 0;
  frame.size = self.scrollView.frame.size;
  [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void)setMode: (int) mode {
  self.mode = mode;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
  self.scrollView = nil;
}

- (IBAction)toggleMapLock:(id)sender {
  MKMapView *mapView = mapViewController.mapView;
  
  BOOL enabled = !mapView.isScrollEnabled;
  
  if(enabled) {
    [lockUnlockButton setTitle:@"\uf09c" forState:UIControlStateNormal];
  } else {
    [lockUnlockButton setTitle:@"\uf023" forState:UIControlStateNormal];
  }
  
  [mapView setZoomEnabled: enabled];
  [mapView setScrollEnabled: enabled];
  [mapView setUserInteractionEnabled: enabled];
}

- (IBAction)findMe:(id)sender {
  if(![self.mapViewController isTracking]) {
    [self.mapViewController startTracking];
  }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  position = [self getCurrentPosition];
  
  int x = scrollView.contentOffset.x;
  float width = scrollView.frame.size.width;
  int sign = 1;
  int ref = 0;
  float marginTopPercentage = 0;
  float marginTop = 0;
  
  if(x <= width) {
    sign = -1;
    ref = 1;
  } else {
    x -= width;
  }
  
  marginTopPercentage = ref + (sign * (x / width));
  marginTopPercentage = fmaxf(marginTopPercentage, 0);
  marginTopPercentage = fminf(marginTopPercentage, 1);
  marginTop = tabsView.frame.size.height * (-1 * marginTopPercentage);
  
  CGRect newTabFrame;
  
  newTabFrame.size = tabFrame.size;
  newTabFrame.origin.x = tabFrame.origin.x;
  newTabFrame.origin.y = tabFrame.origin.y + marginTop;
  
  tabsView.frame = newTabFrame;
  
  switch(position) {
    case INDEX_SECTION_MAP:
      leftNavButton.title = @"Inbox";
      rightNavButton.title = @"Friends";
      self.navigationBar.topItem.title = @"Mapiz";
      break;
    case INDEX_SECTION_INBOX:
      leftNavButton.title = @"Settings";
      rightNavButton.title = @"Back";
      self.navigationBar.topItem.title = @"Inbox";
      break;
    case INDEX_SECTION_FRIENDS:
      leftNavButton.title = @"Back";
      rightNavButton.title = @"Search";
      self.navigationBar.topItem.title = @"Friends";
      break;
  }
  
  
  
}

-(int)getCurrentPosition
{
  CGFloat offset = self.scrollView.contentOffset.x;
  CGFloat width = self.scrollView.frame.size.width * TOTAL_SECTIONS;
  CGFloat percentage = roundf(100 * (offset / width));
  CGFloat val = (percentage/(float)100) * TOTAL_SECTIONS;
  
  return roundf(val);
}

@end
