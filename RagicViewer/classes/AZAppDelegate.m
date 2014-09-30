//
//  AZAppDelegate.m
//  RagicRestClient
//
//  Created by azuritul on 2014/8/25.
//  Copyright (c) 2014 Azuritul. All rights reserved.
//

#import "AZAppDelegate.h"
#import "AZRagicTabFolderTableViewController.h"
#import "AZLoginHomeViewController.h"
#import "AZRagicTabFolderTableViewController.h"

@implementation AZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //should check credentials before dispatching viewcontroller
    NSString * apikey = [[NSUserDefaults standardUserDefaults] objectForKey:@"ragic_apikey"];
    //Dispatch to normal viewcontroller (with menu)
    if(apikey != nil) {
        
        //        RagicHomeViewController *homeViewController = [[[RagicHomeViewController alloc] init] autorelease];
        AZRagicTabFolderTableViewController * leftMenuViewController = [[[AZRagicTabFolderTableViewController alloc] init] autorelease];
        UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:leftMenuViewController] autorelease];
        //        PKRevealController *revealController = [PKRevealController revealControllerWithFrontViewController:navigationController leftViewController:leftMenuViewController];
        //        revealController.delegate = self;
        //        revealController.animationDuration = 0.25;
        //        [revealController setMinimumWidth:140 maximumWidth:220 forViewController:leftMenuViewController];
        self.window.rootViewController = navigationController;
        
    } else { //Dispatch to login view controller
        AZLoginHomeViewController * controller = [[[AZLoginHomeViewController alloc] init] autorelease];
//        UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
//        navigationController.navigationBar.hidden = YES;
        self.window.rootViewController = controller;
        
    }
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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

@end