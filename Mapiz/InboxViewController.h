//
//  InboxViewController.h
//  Mapiz
//
//  Created by samuel on 08/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapizUser.h"
#import "MapizPin.h"
#import "MapizPinTableViewCell.h"
#import "MapizViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MapizDDPClient.h"
#import "MapizPinViewController.h"

@interface InboxViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate, UITableViewDataSource, MapizDDPDelegate, UIAlertViewDelegate> {
  IBOutlet UITableView *tableView;
  
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) UIRefreshControl *refreshControl;
@property (nonatomic, weak) MapizViewController* mapizViewController;

- (void)didReceiveAuthUserDetails:(MapizUser *)user;
- (void)updateMyLocation:(CLLocation *)location;
- (void)didConnect;
- (void)didAuth;

@end
