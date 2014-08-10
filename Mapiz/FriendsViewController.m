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

NSDictionary *friends;
static NSString *letters = @"abcdefghijklmnopqrstuvwxyz";
NSInteger sectionNumber;

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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [letters length];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Number of rows is the number of time zones in the region for the specified section.
  NSArray *users = [friends objectForKey: [letters substringWithRange:NSMakeRange(section, 1)]];
  return [users count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  // The header for the section is the region name -- get this from the region at the section index.
  NSString *header = [letters substringWithRange:NSMakeRange(section, 1)];
  return header;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *MyIdentifier = @"MyReuseIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
  }
//  MapizUser *user = [friends objectAtIndex:indexPath.section];
//  TimeZoneWrapper *timeZoneWrapper = [region.timeZoneWrappers objectAtIndex:indexPath.row];
  cell.textLabel.text = @"test";
  return cell;
}

@end
