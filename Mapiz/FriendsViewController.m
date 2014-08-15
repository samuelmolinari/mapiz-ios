//
//  FriendsViewController.m
//  Mapiz
//
//  Created by samuel on 08/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "FriendsViewController.h"
#import "MapizUser.h"


@implementation FriendsViewController

@synthesize submitButton;
@synthesize tableView;
@synthesize friendLabel;
@synthesize addFriendView;
@synthesize selectedFriends;

BOOL refreshFriendsList = YES;

NSMutableDictionary *friends;

static NSString *letters = @"abcdefghijklmnopqrstuvwxyz";
NSString *query;
NSInteger sectionNumber;
UIRefreshControl *refreshControl;
UIView *header;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  tableView.delegate = self;
  tableView.dataSource = self;
  selectedFriends = [[NSMutableArray alloc] init];
  friends = [[NSMutableDictionary alloc] init];
  
  refreshControl = [[UIRefreshControl alloc]init];
  [self.tableView addSubview:refreshControl];
  [refreshControl addTarget:self action:@selector(reloadFriends) forControlEvents:UIControlEventValueChanged];
  [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.15]];
  [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.001]];
  UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,125)];
  header = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,44)];
  tableView.tableFooterView = footer;
}

-(void) reloadFriends {
  [MapizUser callMyFriends:^(NSDictionary *response, NSError *error) {
    [refreshControl endRefreshing];
    if(!error) {
      NSArray *friends = [response objectForKey:@"result"];
      MapizDBManager *dbManager = [MapizDBManager getSharedInstance];
      [dbManager resetUserTable];
      [dbManager saveUsers:friends];
      [self.tableView reloadData];
    }
    
  }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [letters length];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Number of rows is the number of time zones in the region for the specified section.
  NSArray *users = [[MapizDBManager getSharedInstance] searchUsersStartingWithLetter:[letters substringWithRange:NSMakeRange(section, 1)] query: query];
  [friends setObject:users forKey:[NSString stringWithFormat: @"%d", (int)section]];
  return [users count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  // The header for the section is the region name -- get this from the region at the section index.
  NSString *header = [letters substringWithRange:NSMakeRange(section, 1)];
  return [header uppercaseString];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
    return 0;
  } else {
    return 30;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *MyIdentifier = @"friendCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
//    [cell setSelected:NO animated:NO];
  }
  
  NSArray *users = [friends objectForKey:[NSString stringWithFormat: @"%d", (int)indexPath.section]];
  MapizUser *user = [users objectAtIndex:indexPath.row];
  
  if([selectedFriends indexOfObject:user._id] != NSNotFound) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  cell.textLabel.text = user.username;
  cell.detailTextLabel.text = user.displayName;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSArray *users = [friends objectForKey:[NSString stringWithFormat: @"%d", (int)indexPath.section]];
  MapizUser *user = [users objectAtIndex:indexPath.row];
  if([selectedFriends indexOfObject:user._id] != NSNotFound) {
    [selectedFriends removeObjectAtIndex:[selectedFriends indexOfObject:user._id]];
  } else {
    [selectedFriends addObject:user._id];
  }
  
  [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}

- (void)didAuth {
  if(refreshFriendsList) {
    [refreshControl beginRefreshing];
    [self reloadFriends];
  }
}

- (IBAction)submitWhereAreYou:(id)sender {
  if([selectedFriends count] > 0) {
    [submitButton setUserInteractionEnabled: NO];
    [MapizPin callWhereAreYou:selectedFriends responseCallback:^(NSDictionary *response, NSError *error) {
      [submitButton setUserInteractionEnabled: YES];
      if(error) {
        
      } else {
        [self resetSelections];
        
      }
    }];
  }
}

- (IBAction)addFriend:(id)sender {
  [MapizUser callAddFriend:query responseCallback:^(NSDictionary *response, NSError *error) {
    if(error) {
      [ToastView showToastInParentView:self.view withText:error.localizedDescription withDuaration:5.0];
    } else {
      MapizUser *user = [[MapizUser alloc] initWithResponse: [response valueForKey:@"result"]];
      
      [[MapizDBManager getSharedInstance] saveUser: user];
      
      [selectedFriends addObject:user._id];
      [tableView reloadData];
    }
  }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  query = searchText;
  friendLabel.text = query;
  if([query length] > 0) {
    [addFriendView setHidden:NO];
    tableView.tableHeaderView = header;
  } else {
    [addFriendView setHidden:YES];
    tableView.tableHeaderView = NULL;
  }
  [friends removeAllObjects];
  [tableView reloadData];
}

- (void) resetSelections {
  [selectedFriends removeAllObjects];
  [tableView reloadData];
}

@end
