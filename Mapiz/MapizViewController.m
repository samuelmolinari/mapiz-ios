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
@synthesize submitButton;

int const MODE_IM_HERE = 0;
int const MODE_WHERE_ARE_YOU = 1;

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
  
  mode = MODE_WHERE_ARE_YOU;
  
  self.inboxViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InboxViewController"];
  self.mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
  self.friendsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsViewController"];
  
  [lockUnlockButton.titleLabel setFont: [UIFont fontWithName:@"FontAwesome" size:20]];
  [lockUnlockButton setTitle:@"\uf023" forState:UIControlStateNormal];
  
  [findMeButton.titleLabel setFont: [UIFont fontWithName:@"FontAwesome" size:20]];
  [findMeButton setTitle:@"\uf05b" forState:UIControlStateNormal];
  
  [meetupButton.titleLabel setFont: [UIFont fontWithName:@"FontAwesome" size:20]];
  [meetupButton setTitle:@"\uf073" forState:UIControlStateNormal];
  
  [submitButton.titleLabel setFont: [UIFont fontWithName:@"Glyphicons" size:20]];
  [submitButton setTitle:@"\ue422" forState:UIControlStateNormal];
  
  
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
  friendsFrame.size = size;
  friendsFrame.origin.x = size.width * INDEX_SECTION_FRIENDS;
  friendsFrame.origin.y = 0;
  
  self.inboxViewController.view.frame = inboxFrame;
  self.mapViewController.view.frame = mapFrame;
  self.friendsViewController.view.frame = friendsFrame;
  
  [self.scrollView addSubview: self.mapViewController.view];
  [self.scrollView addSubview: self.friendsViewController.view];
  [self.scrollView addSubview: self.inboxViewController.view];
  
  tabFrame = tabsView.frame;
  
  [self moveToPosition: INDEX_SECTION_MAP];
  
  [self.view layoutIfNeeded];
  
  mapViewController.mapizViewController = self;
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
      break;
  }
}

- (IBAction)goToLeft:(id)sender {
  switch(position) {
    case INDEX_SECTION_MAP:
      if([self isInModeWhereAreYou]) {
        [self moveToPosition:INDEX_SECTION_INBOX];
      }
      [self cancelMode];
      break;
    case INDEX_SECTION_INBOX:
      [self cancelMode];
      break;
    case INDEX_SECTION_FRIENDS:
      [self cancelMode];
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

- (void)setMode: (int) modeValue {
  mode = modeValue;
  switch(mode) {
    case MODE_IM_HERE:
      [self moveToPosition:INDEX_SECTION_FRIENDS];
      [self lockMap];
      [submitButton setHidden: NO];
      [lockUnlockButton setEnabled:NO];
      [findMeButton setEnabled:NO];
      [mapViewController.pinButton setEnabled:NO];
      [friendsViewController.submitButton setHidden: YES];
      break;
    case MODE_WHERE_ARE_YOU:
      [submitButton setHidden: YES];
      [lockUnlockButton setEnabled:YES];
      [findMeButton setEnabled:YES];
      [mapViewController.pinButton setEnabled:YES];
      [mapViewController.submitButton setHidden: NO];
      [friendsViewController.submitButton setHidden: NO];
      break;
  }
}

- (IBAction)submit:(id)sender {
  if([self isInModeImHere]) {
    switch (position) {
      case INDEX_SECTION_INBOX:
      case INDEX_SECTION_MAP:
        [self moveToPosition:INDEX_SECTION_FRIENDS];
        [self lockMap];
        break;
      default:
        break;
    }
  }
}

- (void)cancelMode {
  switch(mode) {
    case MODE_IM_HERE:
      [self setModeWhereAreYou];
      break;
  }
  
  switch(position) {
    case INDEX_SECTION_MAP:
      leftNavButton.title = @"Inbox";
      break;
    case INDEX_SECTION_INBOX:
      leftNavButton.title = @"Settings";
      break;
    case INDEX_SECTION_FRIENDS:
      leftNavButton.title = @"Back";
      break;
  }
}

- (void)setModeImHere {
  [self setMode: MODE_IM_HERE];
}

- (void)setModeWhereAreYou {
  [self setMode: MODE_WHERE_ARE_YOU];
}

- (BOOL) isInModeImHere {
  return mode == MODE_IM_HERE;
}

- (BOOL) isInModeWhereAreYou {
  return mode == MODE_WHERE_ARE_YOU;
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
  
  if(!mapView.isScrollEnabled) {
    [self unlockMap];
  } else {
    [self lockMap];
  }
}

- (void)lockMap {
  [lockUnlockButton setTitle:@"\uf023" forState:UIControlStateNormal];
  [mapViewController lockMap];
}

- (void)unlockMap {
  [lockUnlockButton setTitle:@"\uf09c" forState:UIControlStateNormal];
  [mapViewController unlockMap];
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
      switch (mode) {
        case MODE_IM_HERE:
          leftNavButton.title = @"Cancel";
          break;
        case MODE_WHERE_ARE_YOU:
          leftNavButton.title = @"Inbox";
          break;
      }
      
      rightNavButton.title = @"Friends";
      self.navigationBar.topItem.title = @"Mapiz";
      
      if([self isInModeImHere]) {
        [submitButton setTitle:@"\ue224" forState:UIControlStateNormal];
      } else {
        [submitButton setTitle:@"\ue422" forState:UIControlStateNormal];
      }
      
      break;
    case INDEX_SECTION_INBOX:
      
      switch (mode) {
        case MODE_IM_HERE:
          leftNavButton.title = @"Cancel";
          break;
        case MODE_WHERE_ARE_YOU:
          leftNavButton.title = @"Settings";
          break;
      }
      
      rightNavButton.title = @"Back";
      self.navigationBar.topItem.title = @"Inbox";
      
      if([self isInModeImHere]) {
        [submitButton setTitle:@"\ue224" forState:UIControlStateNormal];
      } else {
        [submitButton setTitle:@"\ue422" forState:UIControlStateNormal];
      }
      
      break;
    case INDEX_SECTION_FRIENDS:
      switch (mode) {
        case MODE_IM_HERE:
          leftNavButton.title = @"Cancel";
          break;
        case MODE_WHERE_ARE_YOU:
          leftNavButton.title = @"Back";
          break;
      }
      
      [submitButton setTitle:@"\ue422" forState:UIControlStateNormal];
      
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
