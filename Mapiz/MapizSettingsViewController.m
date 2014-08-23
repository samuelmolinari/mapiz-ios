//
//  MapizSettingsViewController.m
//  Mapiz
//
//  Created by samuel on 19/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizSettingsViewController.h"
#import "MapizUser.h"
#import "UIColor+CustomColors.h"

@interface MapizSettingsViewController ()

@end

@implementation MapizSettingsViewController

MapizDDPClient *mapizDDPClient;
NSString *usernameTitle = @"Username";
NSString *emailTitle = @"Email";
NSString *displayNameTitle = @"Display name";
NSString *passwordTitle = @"Password";

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
  
  UILongPressGestureRecognizer *usernameLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                                                         action:@selector(handleLongPress:)];
  UILongPressGestureRecognizer *emailLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                                                         action:@selector(handleLongPress:)];
  UILongPressGestureRecognizer *displayNameLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                                                         action:@selector(handleLongPress:)];
  double minimumPressDuration = 0.2;
  usernameLongPress.minimumPressDuration = minimumPressDuration;
  emailLongPress.minimumPressDuration = minimumPressDuration;
  displayNameLongPress.minimumPressDuration = minimumPressDuration;
  
  [_usernameView addGestureRecognizer:usernameLongPress];
  [_emailView addGestureRecognizer:emailLongPress];
  [_displayNameView addGestureRecognizer:displayNameLongPress];
  
  UITapGestureRecognizer *usernameClick=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(usernameClick:)];
  [_usernameView addGestureRecognizer:usernameClick];
  
  UITapGestureRecognizer *emailClick=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emailClick:)];
  [_emailView addGestureRecognizer:emailClick];
  
  UITapGestureRecognizer *displayNameClick=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayNameClick:)];
  [_displayNameView addGestureRecognizer:displayNameClick];
  
  UITapGestureRecognizer *passwordClick=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(passwordClick:)];
  [_passwordView addGestureRecognizer:passwordClick];
  
  [self refreshDetails];
}

-(void)usernameClick: (UITapGestureRecognizer*) recogniser {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:usernameTitle message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
  alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
  UITextField *textfield =  [alertView textFieldAtIndex: 0];
  [textfield setText:[MapizUser getUsername]];
  [alertView show];
}

-(void)emailClick: (UITapGestureRecognizer*) recogniser {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:emailTitle message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
  alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
  UITextField *textfield =  [alertView textFieldAtIndex: 0];
  [textfield setText:[MapizUser getEmail]];
  [alertView show];
}

-(void)displayNameClick: (UITapGestureRecognizer*) recogniser {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayNameTitle message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
  alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
  UITextField *textfield =  [alertView textFieldAtIndex: 0];
  [textfield setText:[MapizUser getDisplayName]];
  [alertView show];
}

-(void)passwordClick: (UITapGestureRecognizer*) recogniser {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:passwordTitle message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
  alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
  UITextField *currentPassword =  [alertView textFieldAtIndex: 0];
  UITextField *newPassword =  [alertView textFieldAtIndex: 1];
  currentPassword.secureTextEntry = YES;
  currentPassword.placeholder = @"Current password";
  newPassword.placeholder = @"New password";
  [alertView show];
}

-(void) refreshDetails {
  [_displayName setText:[MapizUser getDisplayName]];
  [_username setText:[MapizUser getUsername]];
  [_email setText:[MapizUser getEmail]];
}

- (void)handleLongPress: (UILongPressGestureRecognizer*) recogniser {
  if(recogniser.state == UIGestureRecognizerStateBegan) {
    [recogniser.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
  } else if(recogniser.state == UIGestureRecognizerStateEnded) {
    [recogniser.view setBackgroundColor:[UIColor whiteColor]];
  }
}

- (IBAction)goBack:(id)sender {
  [self dismissViewControllerAnimated:YES completion:Nil];
}

-(void)didReceiveAuthUserDetails:(MapizUser *)user {
  
}

-(void)didConnect {
  
}

- (void)didAuth {

}

-(void) setSuccessStatus:(UILabel *) label {
  [label setTextColor:[UIColor success]];
  label.text = @"Saved";
  [label sizeToFit];
  [label setHidden:NO];
}

-(void) setFailedStatus:(UILabel *) label message:(NSString *) message {
  [label setTextColor:[UIColor danger]];
  label.text = message;
  [label sizeToFit];
  [label setHidden:NO];
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex != 0) {
    NSString *title = alertView.title;
    UITextField *textfield =  [alertView textFieldAtIndex: 0];
    NSString *value = textfield.text;
    if([title isEqualToString:usernameTitle]) {
      _usernameIndicator.hidden = NO;
      [MapizUser callUpdateUsername:value responseCallback:^(NSDictionary *response, NSError *error) {
        _usernameIndicator.hidden = YES;
        if(!error) {
          [MapizUser setUsername:value];
          [self refreshDetails];
          [self setSuccessStatus:_usernameStatus];
        } else {
          [self setFailedStatus:_usernameStatus message:error.localizedDescription];
        }
      }];
    } else if([title isEqualToString:emailTitle]) {
      _emailIndicator.hidden = NO;
      [MapizUser callUpdateEmail:value responseCallback:^(NSDictionary *response, NSError *error) {
        _emailIndicator.hidden = YES;
        if(!error) {
          [MapizUser setEmail:value];
          [self refreshDetails];
          [self setSuccessStatus:_emailStatus];
        } else {
          [self setFailedStatus:_emailStatus message:error.localizedDescription];
        }
      }];
    } else if([title isEqualToString:displayNameTitle]) {
      _displayNameIndicator.hidden = NO;
      [MapizUser callUpdateDisplayName:value responseCallback:^(NSDictionary *response, NSError *error) {
        _displayNameIndicator.hidden = YES;
        if(!error) {
          [MapizUser setDisplayName:value];
          [self refreshDetails];
          [self setSuccessStatus:_displayNameStatus];
        } else {
          [self setFailedStatus:_displayNameStatus message:error.localizedDescription];
        }
      }];
    } else if([title isEqualToString:passwordTitle]) {
      _passwordIndicator.hidden = NO;
      UITextField *newPasswordTextfield =  [alertView textFieldAtIndex: 1];
      NSString *newPassword = newPasswordTextfield.text;
      if([newPassword length] >= 6) {
        [MapizUser callChangePassword:value withNewPassword: newPassword responseCallback:^(NSDictionary *response, NSError *error) {
          _passwordIndicator.hidden = YES;
          if(!error) {
            [self setSuccessStatus:_passwordStatus];
          } else {
            [self setFailedStatus:_passwordStatus message:error.localizedDescription];
          }
        }];
      } else {
        [self setFailedStatus:_passwordStatus message:@"Password is too short (min. 6 characters)"];
        _passwordIndicator.hidden = YES;
      }
    }
  }
}

@end
