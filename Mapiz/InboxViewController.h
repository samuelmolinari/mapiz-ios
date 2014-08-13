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

@interface InboxViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MapizDDPDelegate> {
  
  IBOutlet UITableView *tableView;
  
}

@property (atomic,retain) IBOutlet UITableView *tableView;

- (void)didReceiveAuthUserDetails:(MapizUser *)user;
- (void)didConnect;
- (void)didAuth;

@end
