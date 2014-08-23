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

@synthesize pin;

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
  [self performSelector:@selector(showAuth) withObject:nil afterDelay:1.2];
  [super viewDidLoad];
}

- (void)showAuth {
  
  if(![MapizUser isLoggedIn]) {
    [self performSegueWithIdentifier:@"showAuth" sender:self];
  } else {
    [self performSegueWithIdentifier:@"showMain" sender:self];
  }
}

-(void) handleNotification: (MapizPin*) pin {
  self.pin = pin;
  [self performSegueWithIdentifier:@"showMain" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  MapizViewController *destinationController = segue.destinationViewController;
  MapizSplashViewController *sourceController = sender;
  destinationController.pinFromNotification = sourceController.pin;
  
}

@end
