//
//  AppDelegate.m
//  RestKitDemo2
//
//  Created by Peter Friese on 21.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "UserDetailsController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabbarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [RKClient clientWithBaseURL:@"http://github.com"];
    
    UserDetailsController *userDetailsControllerJson = [[UserDetailsController alloc] init];
    userDetailsControllerJson.protocol = @"json";
    [userDetailsControllerJson setUserName:@"octocat"];
    userDetailsControllerJson.tabBarItem.title = @"User Details (JSON)";
    
    UserDetailsController *userDetailsControllerXml = [[UserDetailsController alloc] init];
    userDetailsControllerXml.protocol = @"xml";
    [userDetailsControllerXml setUserName:@"peterfriese"];
    userDetailsControllerXml.tabBarItem.title = @"User Details (XML)";
    
    UIViewController *dummy = [[UIViewController alloc] init];
    dummy.tabBarItem.title = @"Welcome";
    
    
    tabbarController = [[UITabBarController alloc] init];
    [tabbarController setViewControllers:[NSArray arrayWithObjects:
                                          dummy,
                                          userDetailsControllerJson, 
                                          userDetailsControllerXml,                                           
                                          nil]];
    
    [self.window addSubview:tabbarController.view];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
