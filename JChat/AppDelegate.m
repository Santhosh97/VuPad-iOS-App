//
//  AppDelegate.m
//  JChat
//
//  Created by Masaki Nakada on 11/11/13.
//  Copyright (c) 2013 Masaki Nakada. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "TestFlight.h"
#import "Styles.h"
#import "Flurry.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
    [NSThread sleepForTimeInterval:1.2];
    
    [Parse setApplicationId:@"5uPM0SPrbsiVMrVGrWY3kZUBXxbea63qrzG0fhNw"
                  clientKey:@"XQBQTljpg50LpbaOuf6Uf5Kb6d7kQHAMf6DJu76w"];
    // start of your application:didFinishLaunchingWithOptions // ...
    [TestFlight takeOff:@"1d8ccb4c-7815-4cd9-bbb0-a667531d1287"];
    
 
        // Register for push notifications
    [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    
    [Styles applyStyle];
    [self customizeTabBar];
    
    [Flurry setCrashReportingEnabled:YES];
    //note: iOS only allows one crash reporting tool per app; if using another, set to: NO
    [Flurry startSession:@"7BPMW57WY8V5DNKXH6YT"];
    
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Helper methods

- (void) customizeTabBar
{
       // Assign tab bar item with titles
     UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
     UITabBar *tabBarAppearance = [UITabBar appearance];
     
     [[UITabBar appearance]setTintColor:[UIColor colorWithRed:89/255.0f green:216/255.0f blue:239/255.0f alpha:1]];
     
     
     [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabBarBackground"]];
     [tabBarAppearance setSelectionIndicatorImage:[UIImage imageNamed:@"tabBarSelectedBackground"]];
     
     // iOS7 hack: to make selectionIndicatorImage appear on the selected tab on the first app run
     //[[tabVC tabBar] setSelectionIndicatorImage:[UIImage imageNamed:@"tabBarSelectedBackground"]];
     
     
     NSArray *selectedImages = [NSArray arrayWithObjects:@"inboxSelected", @"friendsSelected", @"cameraSelected",  nil];
     NSArray *unselectedImages = [NSArray arrayWithObjects:@"inbox", @"friends", @"camera", nil];
     
     
     NSArray *items = tabVC.tabBar.items;
     for (int idx = 0; idx < items.count; idx++) {
     UITabBarItem *item = [items objectAtIndex:idx];
     
     UIImage *selectedImage = [UIImage imageNamed:[selectedImages objectAtIndex:idx]];
     UIImage *unselectedImage = [UIImage imageNamed:[unselectedImages objectAtIndex:idx]];
     
    [item setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
     
     }
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [toolBar setBarStyle:UIBarStyleBlack];
    toolBar.translucent = YES;
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    if ([PFUser currentUser])
        [currentInstallation setObject:[PFUser currentUser].objectId forKey:@"owner"];
    [currentInstallation saveInBackground];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}


@end
