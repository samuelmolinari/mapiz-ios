//
//  MapizLoginViewController.m
//  Mapiz
//
//  Created by samuel on 09/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizLoginViewController.h"


@implementation MapizLoginViewController

@synthesize authViewController;
@synthesize loginTextField;
@synthesize passwordTextField;
@synthesize loginButton;

MapizDDPClient *mapizDDPClient;

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
  [super viewDidLoad];
  mapizDDPClient = authViewController.mapizDDPClient;
  loginTextField.delegate = self;
  passwordTextField.delegate = self;
}

- (IBAction)goToSignup:(id)sender {
  [authViewController goToSignup];
}

- (IBAction)login:(id)sender {
  NSString *login = [loginTextField.text lowercaseString];
  NSString *password = passwordTextField.text;
  _actionInProgressIndicator.hidden = NO;
  loginButton.enabled = NO;
  if (!mapizDDPClient.websocketReady) {
    UIAlertView *notConnectedAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                                message:@"Looks like we were unable to access our servers."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
    [notConnectedAlert show];
    _actionInProgressIndicator.hidden = YES;
    loginButton.enabled = YES;
  }
  
  [mapizDDPClient logonWithUsernameOrEmail:login password:password responseCallback:^(NSDictionary *response, NSError *error){
    _actionInProgressIndicator.hidden = YES;
    loginButton.enabled = YES;
    if (error) {
      UIAlertView *notConnectedAlert = [[UIAlertView alloc] initWithTitle:@"Login error"
                                                                  message:@"Make sure your login details are right or sign up!"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
      [notConnectedAlert show];
      return;
    }
    
    [self.authViewController handleAuth: response];
    
  }];

}

@end
