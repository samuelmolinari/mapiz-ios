//
//  MapizAppDelegate.h
//  Mapiz
//
//  Created by samuel on 07/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MeteorClient.h>
#import "MapizUser.h"
#import "MapizPin.h"
#import "MapizSplashViewController.h"

@interface MapizAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) MeteorClient *meteorClient;

@end
