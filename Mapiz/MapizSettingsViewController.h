//
//  MapizSettingsViewController.h
//  Mapiz
//
//  Created by samuel on 19/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapizDDPClient.h"

@interface MapizSettingsViewController : UIViewController<MapizDDPDelegate,UIAlertViewDelegate> {
  
  IBOutlet UIView *usernameView;
  IBOutlet UIView *emailView;
  IBOutlet UIView *displayNameView;
  IBOutlet UIView *passwordView;
  
  IBOutlet UILabel *displayName;
  IBOutlet UILabel *email;
  IBOutlet UILabel *username;
  
  IBOutlet UILabel *usernameStatus;
  IBOutlet UILabel *emailStatus;
  IBOutlet UILabel *displayNameStatus;
  IBOutlet UILabel *passwordStatus;
  
  IBOutlet UIActivityIndicatorView *usernameIndicator;
  IBOutlet UIActivityIndicatorView *emailIndicator;
  IBOutlet UIActivityIndicatorView *displayNameIndicator;
  IBOutlet UIActivityIndicatorView *passwordIndicator;
}

@property (nonatomic,retain) IBOutlet UIView *usernameView;
@property (nonatomic,retain) IBOutlet UIView *emailView;
@property (nonatomic,retain) IBOutlet UIView *displayNameView;
@property (nonatomic,retain) IBOutlet UIView *passwordView;

@property (nonatomic,retain) IBOutlet UILabel *usernameStatus;
@property (nonatomic,retain) IBOutlet UILabel *emailStatus;
@property (nonatomic,retain) IBOutlet UILabel *displayNameStatus;
@property (nonatomic,retain) IBOutlet UILabel *passwordStatus;

@property (nonatomic,retain) IBOutlet UILabel *displayName;
@property (nonatomic,retain) IBOutlet UILabel *email;
@property (nonatomic,retain) IBOutlet UILabel *username;

@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *usernameIndicator;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *emailIndicator;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *displayNameIndicator;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *passwordIndicator;

@end
