//
//  MapizViewController.h
//  Mapiz
//
//  Created by samuel on 07/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapizPrimaryImportantCircleButton.h"

@class MapViewController;
@class InboxViewController;
@class FriendsViewController;

@interface MapizViewController : UIViewController<UIScrollViewDelegate> {
  IBOutlet UIScrollView *scrollView;
  IBOutlet UIBarButtonItem *rightNavButton;
  IBOutlet UIBarButtonItem *leftNavButton;
  IBOutlet UINavigationBar *navigationBar;
  IBOutlet UIButton *lockUnlockButton;
  IBOutlet UIButton *findMeButton;
  IBOutlet UIButton *meetupButton;
  IBOutlet UIView *tabsView;
  IBOutlet MapizPrimaryImportantCircleButton *submitButton;
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
@property (nonatomic, retain) IBOutlet MapizPrimaryImportantCircleButton *submitButton;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)setModeImHere;

@end
