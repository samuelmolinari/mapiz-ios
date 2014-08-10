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

MeteorClient *meteorClient;

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
  meteorClient = authViewController.meteorClient;
}

- (IBAction)goToSignup:(id)sender {
  [authViewController goToSignup];
}

- (IBAction)login:(id)sender {
  NSString *login = [loginTextField.text lowercaseString];
  NSString *password = passwordTextField.text;
  
  if (!meteorClient.websocketReady) {
    UIAlertView *notConnectedAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                                message:@"Looks like we were unable to access our servers."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
    [notConnectedAlert show];
  }
  
  [meteorClient logonWithUsernameOrEmail:login password:password responseCallback:^(NSDictionary *response, NSError *error){
    if (error) {
      UIAlertView *notConnectedAlert = [[UIAlertView alloc] initWithTitle:@"Login error"
                                                                  message:@"Make sure your login details are right or sign up!"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
      [notConnectedAlert show];
      return;
    }
    
    [self.authViewController handleAuth];
  }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
