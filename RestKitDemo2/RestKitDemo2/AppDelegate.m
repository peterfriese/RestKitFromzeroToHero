//
//  AppDelegate.m
//  RestKitDemo2
//
//  Created by Peter Friese on 25.06.12.
//  Copyright (c) 2012 Peter Friese. All rights reserved.
//

#import "AppDelegate.h"
#import "GithubUser.h"

@implementation AppDelegate

@synthesize showUserDetailsViewController;

- (void)initRestKit
{
//    // create client with base URL
//    RKClient *client = [RKClient clientWithBaseURLString:@"http://api.github.com"];
    
//    // send unique identifier on each request
//    [client setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forHTTPHeaderField:@"X-UDID"];
    
    // Init RestKit
    [RKObjectManager objectManagerWithBaseURLString:@"https://api.github.com"];
    [[[RKObjectManager sharedManager] client] setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forHTTPHeaderField:@"X-UDID"];
        
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self initRestKit];

    self.showUserDetailsViewController = [[ShowUserDetailsViewController alloc] init];
    [self.window setRootViewController:self.showUserDetailsViewController];
    
    [self.showUserDetailsViewController setUserName:@"peterfriese"];

//    self.window.backgroundColor = [UIColor greenColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
