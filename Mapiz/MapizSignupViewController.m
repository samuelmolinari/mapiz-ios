//
//  MapizSignupViewController.m
//  Mapiz
//
//  Created by samuel on 09/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizSignupViewController.h"

@implementation MapizSignupViewController

@synthesize authViewController;
@synthesize usernameTextField;
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize signupButton;
@synthesize backButton;

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
  meteorClient = self.authViewController.meteorClient;
}
- (IBAction)goBack:(id)sender {
  [authViewController goToSignin];
}

- (IBAction)signup:(id)sender {
  NSString *username = [usernameTextField.text lowercaseString];
  NSString *email = [emailTextField.text lowercaseString];
  NSString *password = passwordTextField.text;
  
  if([password length] < 6) {
    [self handleSignupError: @"Password required. Should be at least 6 characters long"];
    return;
  }
  
  [meteorClient signupWithUsernameAndEmail:username email:email password:password fullname:@"" responseCallback:^(NSDictionary *response, NSError *error) {
    
    if(error) {
      [self handleSignupError: [error localizedDescription]];
    } else {
      [self.authViewController handleAuth];
    }
    
  }];
}

-(void) handleSignupError: (NSString*) description {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signup error"
                                                              message: description
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
  [alert show];
}

@end
