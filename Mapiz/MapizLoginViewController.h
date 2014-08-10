//
//  MapizLoginViewController.h
//  Mapiz
//
//  Created by samuel on 09/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapizAuthViewController.h"

@interface MapizLoginViewController : UIViewController {
  IBOutlet UIButton *signupButton;
  IBOutlet UIButton *loginButton;
  IBOutlet UITextField *loginTextField;
  IBOutlet UITextField *passwordTextField;
}
@property (nonatomic, weak) MapizAuthViewController* authViewController;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) IBOutlet UIButton *signupButton;
@property (nonatomic, retain) IBOutlet UITextField *loginTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;



@end
