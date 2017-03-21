//
//  AppDelegate.m
//  D2brain
//
//  Created by webmyne systems on 29/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    application.applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UILocalNotification *localnotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (localnotification) {
        application.applicationIconBadgeNumber = 0;
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NV"]isEqualToString:@"1"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [[NSUserDefaults standardUserDefaults]setObject:@"MAINCONTAINER1" forKey:@"storyboardID"];
       
        UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"MENU_DRAWER"];
        
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
    }
    else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"NV2"];
        
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication*)application  didReceiveLocalNotification:(nonnull UILocalNotification *)notification{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hitScheduledURL" object:self];
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

@end
