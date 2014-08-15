//
//  MapizViewController.h
//  Mapiz
//
//  Created by samuel on 07/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapizPrimaryImportantCircleButton.h"
#import "MapizDDPClient.h"
#import "MapizUser.h"
#import "MapizPin.h"
#import "ILTranslucentView.h"

@class MapViewController;
@class InboxViewController;
@class FriendsViewController;

@interface MapizViewController : UIViewController<UIScrollViewDelegate, MapizDDPDelegate,UISearchBarDelegate> {
  IBOutlet UIScrollView *scrollView;
  IBOutlet UIBarButtonItem *rightNavButton;
  IBOutlet UIBarButtonItem *leftNavButton;
  IBOutlet UINavigationBar *navigationBar;
  IBOutlet UIButton *lockUnlockButton;
  IBOutlet UIButton *findMeButton;
  IBOutlet UIButton *meetupButton;
  IBOutlet UIView *tabsViewContainer;
  IBOutlet UIView *tabsView;
  IBOutlet UITabBar *tabsBackground;
  IBOutlet MapizPrimaryImportantCircleButton *submitButton;
  IBOutlet UISearchBar *searchBar;
  IBOutlet ILTranslucentView *meetupSetupView;
  IBOutlet UIDatePicker *datePicker;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) MapViewController *mapViewController;
@property (nonatomic, retain) InboxViewController *inboxViewController;
@property (nonatomic, retain) FriendsViewController *friendsViewController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *leftNavButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *rightNavButton;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UIButton *lockUnlockButton;
@property (nonatomic, retain) IBOutlet UIButton *findMeButton;
@property (nonatomic, retain) IBOutlet UIButton *meetupButton;
@property (nonatomic, retain) IBOutlet UIView *tabsView;
@property (nonatomic, retain) IBOutlet UIView *tabsViewContainer;
@property (nonatomic, retain) IBOutlet UIView *tabsBackground;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet ILTranslucentView *meetupSetupView;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet MapizPrimaryImportantCircleButton *submitButton;
@property (nonatomic, strong) MapizDDPClient *mapizDDPClient;
@property (nonatomic, retain) MapizPin *replyTo;
@property (nonatomic, retain) NSDate *locationSavedAt;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)setModeImHere:(CLLocation *)location;
- (void)setModeMeetMeThere:(CLLocation *)location;

- (void)setModeReplyTo:(MapizPin *)pin;

- (BOOL)isInModeReplyTo;
- (void)cancelMode;
- (void)lockMap;

- (void)didReceiveAuthUserDetails:(MapizUser *)user;
- (void)didConnect;
- (void)didAuth;

@end
