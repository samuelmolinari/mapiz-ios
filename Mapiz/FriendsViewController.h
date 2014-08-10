//
//  FriendsViewController.h
//  Mapiz
//
//  Created by samuel on 08/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
  IBOutlet UIButton *submitButton;
  IBOutlet UITableView *tableView;
}

@property (nonatomic, retain) IBOutlet UIButton *submitButton;

@end
