//
//  InboxViewController.m
//  Mapiz
//
//  Created by samuel on 08/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "InboxViewController.h"

@interface InboxViewController ()

@end

@implementation InboxViewController

int pageLoaded = 0;
int bulkSize = 50;
int loadNextPageBeforeLast = 10;
NSMutableArray * items;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  _tableView.delegate = self;
  _tableView.dataSource = self;
  
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *MyIdentifier = @"pinCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  
  MapizPin *pin = [[MapizPin alloc] initWithResponse: [items objectAtIndex:indexPath.row]];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
  }
  
  

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}

- (void)didReceiveAuthUserDetails:(MapizUser *)user {
  
}

- (void)didConnect {
  
}

- (void)didAuth {
  [MapizUser callMyInbox:^(NSDictionary *response, NSError *error) {
    items = [response objectForKey:@"result"];
    [_tableView reloadData];
  }];
}

@end
