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
@synthesize tabsViewContainer;
@synthesize tabsBackground;
@synthesize submitButton;
@synthesize navigationBar;
@synthesize mapizDDPClient;
@synthesize replyTo;
@synthesize locationSavedAt;

int const MODE_IM_HERE = 0;
int const MODE_WHERE_ARE_YOU = 1;
int const MODE_MEET_ME_THERE = 2;
int const MODE_REPLY_TO = 3;

int const TOTAL_SECTIONS = 3;
int const INDEX_SECTION_INBOX = 0;
int const INDEX_SECTION_MAP = 1;
int const INDEX_SECTION_FRIENDS = 2;

int mode;
int position;

CGRect tabFrame;
CLLocation *savedLocation;
MapizUser *authUser;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.mapizDDPClient = [MapizDDPClient getInstance];
  self.mapizDDPClient.delegate = self;
  
  if(![self.navigationController.navigationBar respondsToSelector:@selector(barTintColor)]) {
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:208/255 green:66/255 blue:76/255 alpha:1.0];
  }
  
  [_datePicker setMinimumDate:[[NSDate alloc] init]];
  
  [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
  CGSize size = CGSizeMake(30, 30);
  // create context with transparent background
  UIGraphicsBeginImageContextWithOptions(size, NO, 1);
  
  // Add a clip before drawing anything, in the shape of an rounded rect
  [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0,30,30)
                              cornerRadius:5.0] addClip];
  [[UIColor whiteColor] setFill];
  
  UIRectFill(CGRectMake(0, 0, size.width, size.height));
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  [self.searchBar setSearchFieldBackgroundImage:image forState:UIControlStateNormal];
  self.searchBar.delegate = self;
  
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
  
  [rightNavButton setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont fontWithName:@"FontAwesome" size:16.0f],UITextAttributeFont, nil] forState:UIControlStateNormal];
  [leftNavButton setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont fontWithName:@"FontAwesome" size:16.0f],UITextAttributeFont, nil] forState:UIControlStateNormal];
}

-(void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * TOTAL_SECTIONS, self.scrollView.frame.size.height);
  
  CGSize size = self.scrollView.frame.size;
  
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
  
  [self goToPosition: INDEX_SECTION_MAP];
  
  [self.view layoutIfNeeded];
  
  mapViewController.mapizViewController = self;
  inboxViewController.mapizViewController = self;
}

- (IBAction)goToRight:(id)sender {
  switch(position) {
    case INDEX_SECTION_MAP:
      if(![self isInModeReplyTo]) {
        [self moveToPosition:INDEX_SECTION_FRIENDS];
      }
      break;
    case INDEX_SECTION_INBOX:
      [self moveToPosition:INDEX_SECTION_MAP];
      break;
    case INDEX_SECTION_FRIENDS:
      [self showSearchBar];
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

- (void) setModeReplyTo: (MapizPin*) pin {
  replyTo = pin;
  [self setMode: MODE_REPLY_TO];
  [self.mapViewController.submitButton setTitle:[NSString stringWithFormat:@"Tell %@ I'm here!", pin.sender.username] forState:UIControlStateNormal];
}

- (void)hideSearchBar {
  [self.searchBar setHidden:YES];
}

- (void)showSearchBar {
  [self.searchBar setHidden:NO];
  [self.searchBar becomeFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  [self.searchBar resignFirstResponder];
  [self hideSearchBar];
  [self.friendsViewController searchBar:searchBar textDidChange:@""];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  [self.friendsViewController searchBar:searchBar textDidChange:searchText];
}

- (void)moveToPosition: (int)i {
  CGRect frame;
  frame.origin.x = self.scrollView.frame.size.width * i;
  frame.origin.y = 0;
  frame.size = self.scrollView.frame.size;
  [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void)goToPosition: (int)i {
  CGRect frame;
  frame.origin.x = self.scrollView.frame.size.width * i;
  frame.origin.y = 0;
  frame.size = self.scrollView.frame.size;
  [self.scrollView scrollRectToVisible:frame animated:NO];
}

- (void)setMode: (int) modeValue {
  mode = modeValue;
  switch(mode) {
    case MODE_IM_HERE:
    case MODE_MEET_ME_THERE:
      [self moveToPosition:INDEX_SECTION_FRIENDS];
      [self lockMap];
      [submitButton setHidden: NO];
      [lockUnlockButton setEnabled:NO];
      [findMeButton setEnabled:NO];
      [mapViewController.pinButton setEnabled:NO];
      [friendsViewController.submitButton setHidden: YES];
      break;
    case MODE_REPLY_TO:
      [self moveToPosition:INDEX_SECTION_MAP];
      [self lockMap];
      [submitButton setHidden: YES];
      [lockUnlockButton setEnabled:YES];
      [findMeButton setEnabled:YES];
      [mapViewController.pinButton setEnabled:YES];
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
  if([self isInModeImHere] || [self isInModeMeetMeThere]) {
    switch (position) {
      case INDEX_SECTION_INBOX:
      case INDEX_SECTION_MAP:
        [self moveToPosition:INDEX_SECTION_FRIENDS];
        [self lockMap];
        break;
      default:
        [self.submitButton setUserInteractionEnabled: NO];
        int pinType;
        if([self isInModeImHere]) {
          pinType = PinTypeImHere;
        } else if([self isInModeMeetMeThere]) {
          pinType = PinTypeMeetMeThere;
        }
        
        [MapizPin callSubmitPinOfType:pinType
                         toRecipients:self.friendsViewController.selectedFriends
                      withCoordinates:savedLocation
                                   at:locationSavedAt
                     responseCallback:^(NSDictionary *response, NSError *error) {
          
                       [self.submitButton setUserInteractionEnabled: YES];
                       if(error) {
                       
                       } else {
                         [self cancelMode];
                       }
        }];
        
        break;
    }
  }
}

- (void)cancelMode {
  replyTo = NULL;
  switch(mode) {
    case MODE_IM_HERE:
    case MODE_MEET_ME_THERE:
    case MODE_REPLY_TO:
      [self setModeWhereAreYou];
      [self.mapViewController.submitButton setTitle:@"I'm here!" forState:UIControlStateNormal];
      [self.friendsViewController resetSelections];
      break;
  }
  [UIView performWithoutAnimation:^{
  switch(position) {
    case INDEX_SECTION_MAP:
      leftNavButton.title = @"\uf0e0";
      rightNavButton.title = @"\uf0c0";
      break;
    case INDEX_SECTION_INBOX:
      leftNavButton.title = @"\uf013";
      break;
    case INDEX_SECTION_FRIENDS:
      leftNavButton.title = @"\uf053";
      break;
  }
  }];
}

- (void)setModeImHere {
  [self setMode: MODE_IM_HERE];
}

- (void)setModeMeetMeThere {
  [self setMode: MODE_MEET_ME_THERE];
}

- (void) setModeImHere:(CLLocation *)location {
  [self setModeImHere];
  savedLocation = location;
  locationSavedAt = [[NSDate alloc] init];
}

- (void) setModeMeetMeThere:(CLLocation *)location {
  [self setModeMeetMeThere];
  savedLocation = location;
  // locationSavedAt value already set
}

- (void)setModeWhereAreYou {
  [self setMode: MODE_WHERE_ARE_YOU];
}

- (BOOL) isInModeImHere {
  return mode == MODE_IM_HERE;
}

- (BOOL) isInModeMeetMeThere {
  return mode == MODE_MEET_ME_THERE;
}

- (BOOL) isInModeWhereAreYou {
  return mode == MODE_WHERE_ARE_YOU;
}

- (BOOL) isInModeReplyTo {
  return mode == MODE_REPLY_TO;
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
  marginTop = tabsView.frame.size.height * (1 * marginTopPercentage);
  
  CGRect newTabFrame;
  
  newTabFrame.size = tabFrame.size;
  newTabFrame.origin.x = tabFrame.origin.x;
  newTabFrame.origin.y = tabFrame.origin.y + marginTop;
  
  tabsView.frame = newTabFrame;
  tabsBackground.frame = newTabFrame;
  
  [UIView performWithoutAnimation:^{
  switch(position) {
    case INDEX_SECTION_MAP:
      [tabsViewContainer setUserInteractionEnabled:YES];
      switch (mode) {
        case MODE_IM_HERE:
        case MODE_MEET_ME_THERE:
          leftNavButton.title = @"\uf00d";
          rightNavButton.title = @"\uf0c0";
          break;
        case MODE_WHERE_ARE_YOU:
          leftNavButton.title = @"\uf0e0";
          rightNavButton.title = @"\uf0c0";
          break;
        case MODE_REPLY_TO:
          leftNavButton.title = @"\uf00d";
          rightNavButton.title = @"";
          break;
      }
      
      
      self.navigationBar.topItem.title = @"Mapiz";
      
      if([self isInModeImHere] || [self isInModeMeetMeThere]) {
        submitButton.titleLabel.text = @"\ue224";
      } else {
        submitButton.titleLabel.text = @"\ue422";
      }
      
      break;
    case INDEX_SECTION_INBOX:
      [tabsViewContainer setUserInteractionEnabled:NO];
      switch (mode) {
        case MODE_IM_HERE:
        case MODE_MEET_ME_THERE:
          leftNavButton.title = @"\uf00d";
          break;
        case MODE_WHERE_ARE_YOU:
          leftNavButton.title = @"\uf013";
          break;
      }
      
      rightNavButton.title = @"\uf054";
      self.navigationBar.topItem.title = @"Inbox";
      
      if([self isInModeImHere] || [self isInModeMeetMeThere]) {
        submitButton.titleLabel.text = @"\ue224";
      } else {
        submitButton.titleLabel.text = @"\ue422";
      }
      
      break;
    case INDEX_SECTION_FRIENDS:
      [tabsViewContainer setUserInteractionEnabled:NO];
      switch (mode) {
        case MODE_IM_HERE:
          leftNavButton.title = @"\uf00d";
          break;
        case MODE_WHERE_ARE_YOU:
          leftNavButton.title = @"\uf053";
          break;
      }
      
      submitButton.titleLabel.text = @"\ue422";
      rightNavButton.title = @"\uf002";
      self.navigationBar.topItem.title = @"Friends";
      break;
  }
  }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if([self isInModeReplyTo] && position == INDEX_SECTION_FRIENDS) {
    [self moveToPosition: INDEX_SECTION_MAP];
  }
}

- (IBAction)setupMeetup:(id)sender {
  if([_meetupSetupView isHidden]) {
    [_meetupSetupView setHidden:NO];
  } else {
    [_meetupSetupView setHidden:YES];
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
- (IBAction)cancelMeetupSetup:(id)sender {
  [_meetupSetupView setHidden:YES];
}

- (IBAction)setMeetup:(id)sender {
  [_meetupSetupView setHidden:YES];
  locationSavedAt = [_datePicker date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.doesRelativeDateFormatting = YES;
  dateFormatter.locale = [NSLocale currentLocale];
  dateFormatter.dateStyle = NSDateFormatterShortStyle;
  dateFormatter.timeStyle = NSDateFormatterShortStyle;
  [self.mapViewController.dateLabel setTitle:[dateFormatter stringFromDate:locationSavedAt] forState:UIControlStateNormal];
  [self.mapViewController.dateLabel setHidden:NO];
  [self.mapViewController.submitButton setTitle:@"Meet me there!" forState:UIControlStateNormal];
  
}

-(void)didReceiveAuthUserDetails:(MapizUser *)user {
  [self.mapViewController didReceiveAuthUserDetails:user];
}

-(void)didConnect {
  
}

- (void)didAuth {
  [self.friendsViewController didAuth];
  [self.inboxViewController didAuth];
}

@end
