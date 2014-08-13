//
//  MapizSplashViewController.m
//  Mapiz
//
//  Created by samuel on 09/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizSplashViewController.h"

@interface MapizSplashViewController ()

@end

@implementation MapizSplashViewController

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
//  [MapizUser clearAuthUser];
  [self performSelector:@selector(showAuth) withObject:nil afterDelay:2.0];
  [super viewDidLoad];
}

- (void)showAuth {
  
  if(![MapizUser isLoggedIn]) {
    [self performSegueWithIdentifier:@"showAuth" sender:self];
  } else {
    [self performSegueWithIdentifier:@"showMain" sender:self];
  }
}

@end
