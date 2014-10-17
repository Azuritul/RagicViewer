//
//  AZAppDelegate.m
//  RagicViewer
//
//  Created by azuritul on 2014/8/25.
//  Copyright (c) 2014 Azuritul. All rights reserved.
//

#import "AZAppDelegate.h"
#import "AZRagicTabFolderTableViewController.h"
#import "RagicViewer-Swift.h"

@implementation AZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    //should check credentials before dispatching viewcontroller
    NSString * apikey = [AZRagicSwiftUtils getUserAPIKey];
    if(apikey != nil) {
        TabFolderViewController * rootViewController = [[[TabFolderViewController alloc] init] autorelease];
        UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:rootViewController] autorelease];
        self.window.rootViewController = navigationController;
        
    } else { //Dispatch to login view controller
        LoginHomeViewController * controller = [[[LoginHomeViewController alloc] init] autorelease];
        self.window.rootViewController = controller;
    }
    [[UIApplication sharedApplication] setStatusBarStyle : UIStatusBarStyleLightContent ] ;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

@end