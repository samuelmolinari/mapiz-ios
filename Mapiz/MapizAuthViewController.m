//
//  MapizAuthViewController.m
//  Mapiz
//
//  Created by samuel on 09/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizAuthViewController.h"
#import "MapizLoginViewController.h"
#import "MapizSignupViewController.h"

@interface MapizAuthViewController ()

@end

@implementation MapizAuthViewController
@synthesize loginViewController;
@synthesize signupViewController;
@synthesize scrollView;
@synthesize mapizDDPClient;

int const TOTAL_AUTH_SECTIONS = 2;
int const INDEX_SECTION_LOGIN = 0;
int const INDEX_SECTION_SIGNUP = 1;

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
  
  mapizDDPClient = [MapizDDPClient getInstance];
  mapizDDPClient.delegate = self;
  
  self.loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapizLoginViewController"];
  self.signupViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapizSignupViewController"];
  
  self.loginViewController.authViewController = self;
  self.signupViewController.authViewController = self;
  
  scrollView.scrollEnabled = NO;
}

-(void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * TOTAL_AUTH_SECTIONS, self.scrollView.frame.size.height);
  
  CGSize size = self.scrollView.frame.size;
  
  CGRect loginFrame;
  loginFrame.size = size;
  loginFrame.origin.x = size.width * INDEX_SECTION_LOGIN;
  loginFrame.origin.y = 0;
  
  CGRect signupFrame;
  signupFrame.size = size;
  signupFrame.origin.x = size.width * INDEX_SECTION_SIGNUP;
  signupFrame.origin.y = 0;
  
  self.loginViewController.view.frame = loginFrame;
  self.signupViewController.view.frame = signupFrame;
  
  [self.scrollView addSubview: self.loginViewController.view];
  [self.scrollView addSubview: self.signupViewController.view];
  
  [self.view layoutIfNeeded];

}

-(void) goToSignup {
  CGRect frame;
  frame.origin.x = self.scrollView.frame.size.width * INDEX_SECTION_SIGNUP;
  frame.origin.y = 0;
  frame.size = self.scrollView.frame.size;
  [self.scrollView scrollRectToVisible:frame animated:YES];
}

-(void) goToSignin {
  CGRect frame;
  frame.origin.x = self.scrollView.frame.size.width * INDEX_SECTION_LOGIN;
  frame.origin.y = 0;
  frame.size = self.scrollView.frame.size;
  [self.scrollView scrollRectToVisible:frame animated:YES];
}

-(void)handleAuth: (NSDictionary *) response {
  
  NSDictionary *data = [response valueForKeyPath:@"result"];
  NSString *_id = [data valueForKeyPath:@"id"];
  NSString *email = NULL;
  NSString *username = NULL;
  NSString *displayName = NULL;
  NSString *token = [data valueForKeyPath:@"token"];
  NSDictionary *date = [data valueForKeyPath:@"tokenExpires"];
  NSString *expiresStr = [date valueForKeyPath:@"$date"];
  NSTimeInterval timeInterval = [expiresStr longLongValue] / 1000;
  NSDate *expires = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterval];
  
  [MapizUser callAddApnToken:[MapizUser getApnToken] responseCallback:^(NSDictionary *response, NSError *error) {
    [MapizUser saveAuthUserWithToken:token expires:expires _id:_id username:username email:email displayName:displayName];
    [self performSegueWithIdentifier:@"showMain" sender:self];
  }];
  
}

- (void)didConnect {
  
}

-(void) didReceiveAuthUserDetails:(MapizUser *)user {
  
}

-(void) didAuth {
  
}

@end
