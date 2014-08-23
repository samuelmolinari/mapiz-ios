//
//  MapizSignupViewController.h
//  Mapiz
//
//  Created by samuel on 09/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapizAuthViewController.h"

@interface MapizSignupViewController : UIViewController<UITextFieldDelegate> {
  
  IBOutlet UIButton *backButton;
  IBOutlet UIButton *signupButton;
  IBOutlet UITextField *usernameTextField;
  IBOutlet UITextField *emailTextField;
  IBOutlet UITextField *passwordTextField;
  IBOutlet UIActivityIndicatorView *actionInProgressIndicator;
}
@property (nonatomic, weak) MapizAuthViewController* authViewController;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *signupButton;
@property (nonatomic, retain) IBOutlet UITextField *usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *actionInProgressIndicator;
@end
