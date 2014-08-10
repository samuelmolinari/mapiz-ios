//
//  MapizAuthViewController.h
//  Mapiz
//
//  Created by samuel on 09/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ObjectiveDDP/MeteorClient.h>

@class MapizLoginViewController;
@class MapizSignupViewController;

@interface MapizAuthViewController : UIViewController<UIScrollViewDelegate> {
  
  IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, retain) MapizLoginViewController *loginViewController;
@property (nonatomic, retain) MapizSignupViewController *signupViewController;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) MeteorClient *meteorClient;

-(void)goToSignin;
-(void)goToSignup;
-(void)handleAuth;

@end
