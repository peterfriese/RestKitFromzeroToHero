//
//  AppDelegate.m
//  RestKitSample3
//
//  Created by Peter Friese on 21.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "BrowseReposViewController.h"
#import "BrowseIssuesViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabbarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [RKObjectManager objectManagerWithBaseURL:@"https://api.github.com"];
    
    // Browse repos
    BrowseReposViewController *browseViewController = [[BrowseReposViewController alloc] init];
    UINavigationController *browseReposNavigationController = [[UINavigationController alloc] initWithRootViewController:browseViewController];
    browseReposNavigationController.tabBarItem.title = @"Browse";
    
    // Set up tab bar
    tabbarController = [[UITabBarController alloc] init];
    [tabbarController setViewControllers:[NSArray arrayWithObjects:
                                          browseReposNavigationController, 
                                          nil]];    
    
    [self.window addSubview:tabbarController.view];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
