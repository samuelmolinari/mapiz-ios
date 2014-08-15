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

@interface InboxViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate, UITableViewDataSource, MapizDDPDelegate> {
  
  IBOutlet UITableView *tableView;
  
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UIRefreshControl *refreshControl;
@property (nonatomic, weak) MapizViewController* mapizViewController;

- (void)didReceiveAuthUserDetails:(MapizUser *)user;
- (void)didConnect;
- (void)didAuth;

@end
