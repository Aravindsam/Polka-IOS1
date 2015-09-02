//
//  AppDelegate.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/9/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseCrashReporting/ParseCrashReporting.h>
#import <Parse/PFAnalytics.h>
#import "ViewController.h"
#import "WelcomeViewController.h"
#import "MenuListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    sharedObj=[Generic sharedMySingleton];
    sharedObj.Login=[[NSUserDefaults standardUserDefaults]boolForKey:@"Login"];
  
    //enable carsh and localstorage
    [ParseCrashReporting enable];
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"lBZFCKLlXOMEjY9yyUYDNrTNIluKkqOY38X88pVu"
                  clientKey:@"4WhNgfZ7bFin58wsUNUZJo5Z3OAv9jXMP41QoYnL"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    //Navigating to Screen.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (sharedObj.Login) {
        sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
        sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"Start"];
        
        ViewController *view=[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        sharedObj.Starting=[[NSUserDefaults standardUserDefaults]objectForKey:@"Start"];
        self.navigationController = [[UINavigationController alloc]initWithRootViewController:view];
    }
    else
    {
        WelcomeViewController *view=[storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
         self.navigationController = [[UINavigationController alloc]initWithRootViewController:view];
    }
    
    [ self.navigationController setNavigationBarHidden:YES];
    
    
    //initialise SliderMenu
    MenuListViewController *page =[storyboard instantiateViewControllerWithIdentifier:@"MenuListViewController"];
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:self.navigationController
                                                    leftMenuViewController:page
                                                    rightMenuViewController:nil];
    
    
    [self.window setRootViewController:container];
    [self.window makeKeyAndVisible];
    self.window.frame = [[UIScreen mainScreen] bounds];
    
    
   
    
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
    //register for remote notification
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // use registerUserNotificationSettings
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        // use registerForRemoteNotifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    

    return YES;
}
- (void)presentLoginViewController {
    // Go to the welcome screen and have them log in or create an account.
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
   [PFPush handlePush:userInfo];
    if (application.applicationState == UIApplicationStateInactive) {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }

}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
    }
    sharedObj.deviceToken=deviceToken;
  
 
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code != 3010) { // 3010 is for the iPhone Simulator
        NSLog(@"Application failed to register for push notifications: %@", error);
    }
}
#pragma mark - Silent Notification App Delegate Method

- (void)           application:(UIApplication *)application
  didReceiveRemoteNotification:(NSDictionary *)userInfo
        fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // Storing the notification.
    
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"NOTIFICATION" object:nil];
//    NSString*typenotification =userInfo[@"Type"];
//    NSDictionary *aps = userInfo[@"aps"];
//    NSMutableArray *notifications=[[NSMutableArray alloc]initWithObjects:nil];
//    notifications=[[[NSUserDefaults standardUserDefaults]objectForKey:@"NOTIFICATIONLIST"]mutableCopy];
//    if (notifications==nil) {
//           notifications=[[NSMutableArray alloc]initWithObjects:nil];
//    }
//    if (typenotification.length==0 || typenotification == nil|| [typenotification isEqual:[NSNull null]]) {
//        
//    }
//    else{
//    if (![typenotification isEqualToString:@"Silent"]) {
//        NSDictionary *notificationdict=[[NSDictionary alloc]initWithObjectsAndKeys:userInfo[@"ImageURL"],@"Image",aps[@"alert"],@"Text",userInfo[@"Time"],@"Time",userInfo[@"FeedId"],@"FeedId",userInfo[@"GroupId"],@"GroupId",typenotification,@"Type", nil];
//        if (notifications.count<20) {
//            [notifications insertObject:notificationdict atIndex:0];
//
//        }
//        else
//        {
//            [notifications removeLastObject];
//            [notifications insertObject:notificationdict atIndex:0];
//           
//        }
//        [[NSUserDefaults standardUserDefaults]setObject:notifications forKey:@"NOTIFICATIONLIST"];
    
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadNotification" object:nil];
//    }
//    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadNotification" object:nil];

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
