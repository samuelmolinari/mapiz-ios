//
//  FriendsViewController.h
//  Mapiz
//
//  Created by samuel on 08/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapizViewController.h"
#import "MapizDBManager.h"
#import "MapizPin.h"
#import "ToastView.h"

@interface FriendsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MapizDDPDelegate, UISearchBarDelegate> {
  IBOutlet UIButton *submitButton;
  IBOutlet UITableView *tableView;
  IBOutlet UILabel *friendLabel;
  IBOutlet UIView *addFriendView;
  IBOutlet UIActivityIndicatorView *actionInProgressIndicator;
  IBOutlet UIActivityIndicatorView *friendActionInProgressIndicator;
  IBOutlet UIButton *addFriendButton;
}

@property (nonatomic, retain) IBOutlet UIButton *addFriendButton;
@property (nonatomic, retain) IBOutlet UIButton *submitButton;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *friendLabel;
@property (nonatomic, retain) IBOutlet UIView *addFriendView;
@property (nonatomic, retain) NSMutableArray *selectedFriends;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *actionInProgressIndicator;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *friendActionInProgressIndicator;
@property (nonatomic, weak) MapizViewController* mapizViewController;

- (void)resetSelections;

- (void)didReceiveAuthUserDetails:(MapizUser *)user;
- (void)didConnect;
- (void)didAuth;

@end
