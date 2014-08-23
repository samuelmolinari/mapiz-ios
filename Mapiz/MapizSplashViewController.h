//
//  MapizSplashViewController.h
//  Mapiz
//
//  Created by samuel on 09/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapizAuthViewController.h"
#import "MapizPinViewController.h"
#import "MapizViewController.h"
#import "MapizUser.h"
#import "MapizPin.h"

@interface MapizSplashViewController : UIViewController {
  
}

@property (nonatomic,retain) MapizPin* pin;

-(void) handleNotification: (MapizPin*) pin;

@end
