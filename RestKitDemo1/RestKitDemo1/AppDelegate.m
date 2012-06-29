//
//  AppDelegate.m
//  RestKitDemo1
//
//  Created by Peter Friese on 25.06.12.
//  Copyright (c) 2012 Peter Friese. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize demo1ViewController;

- (void)initRestKit
{
    // create client with base URL
    RKClient *client = [RKClient clientWithBaseURLString:@"http://www.github.org"];
    client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    // send unique identifier on each request
    [client setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forHTTPHeaderField:@"X-UDID"];
    
    client.cachePolicy = RKRequestCachePolicyLoadIfOffline | RKRequestCachePolicyTimeout; // | RKRequestCachePolicyEtag    
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [self initRestKit];

    self.demo1ViewController = [[Demo1ViewController alloc] init];
    [self.window setRootViewController:self.demo1ViewController];
    [self.window addSubview:demo1ViewController.view];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
