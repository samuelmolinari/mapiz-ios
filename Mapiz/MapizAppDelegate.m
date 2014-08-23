//
//  MapizAppDelegate.m
//  Mapiz
//
//  Created by samuel on 07/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizAppDelegate.h"

@implementation MapizAppDelegate

@synthesize meteorClient;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
   (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
 
  [MapizDDPClient getInstance];
  NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
  if([[userInfo valueForKey:@"_collection"] isEqualToString:@"pins"]) {
    MapizPin *pin = [[MapizPin alloc] initWithNotification:userInfo];
    if(pin) {
      MapizSplashViewController *splashViewController = (MapizSplashViewController*) self.window.rootViewController;
      splashViewController.pin = pin;
    }
    NSLog(@"%@", launchOptions);
  }
  
  return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
  
  const unsigned *tokenBytes = [deviceToken bytes];
  NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                        ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                        ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                        ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
  
  if([[MapizUser getApnToken] length] <= 0) {
    [MapizUser saveApnToken:hexToken];
  }
  
	NSLog(@"My token is: %@", hexToken);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
	NSLog(@"Received notification: %@", userInfo);
  if([[userInfo valueForKey:@"_collection"] isEqualToString:@"pins"]) {
    MapizPin *pin = [[MapizPin alloc] initWithNotification:userInfo];
    
    UIViewController *controller = [self topMostController];
    
    if([application applicationState] != UIApplicationStateActive) {
    
      if([controller isKindOfClass:[MapizViewController class]]) {
        MapizViewController *mapizViewController = (MapizViewController*)controller;
        [mapizViewController appearFromNotification: pin];
      } else if(![controller isKindOfClass:[MapizAuthViewController class]] || ![controller isKindOfClass:[MapizSplashViewController class]]) {
        [controller dismissViewControllerAnimated:NO completion:Nil];
        MapizViewController *mapizViewController = (MapizViewController*)[self topMostController];
        [mapizViewController appearFromNotification: pin];
      }
    }
  }
  
}

- (UIViewController*) topMostController {
  UIViewController *topController = self.window.rootViewController;
  
  while (topController.presentedViewController) {
    topController = topController.presentedViewController;
  }
  
  return topController;
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

@end
