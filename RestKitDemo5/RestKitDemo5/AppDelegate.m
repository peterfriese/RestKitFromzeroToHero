//
//  AppDelegate.m
//  RestKitDemo5
//
//  Created by Peter Friese on 27.06.12.
//  Copyright (c) 2012 Peter Friese. All rights reserved.
//

#import "AppDelegate.h"

#import "GithubObjectMappingProvider.h"
#import "BrowseReposViewController.h"
#import "LoginInfo.h"


@implementation AppDelegate

@synthesize navigationController;

- (void)initRestKit
{
    // Init RestKit
    // ------------------------------    
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURLString:@"https://api.github.com"];
    [objectManager.client setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forHTTPHeaderField:@"X-UDID"];
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    objectManager.client.authenticationType = RKRequestAuthenticationTypeHTTPBasic;
    objectManager.serializationMIMEType = RKMIMETypeJSON;
    objectManager.acceptMIMEType = RKMIMETypeJSON;
    
    RKManagedObjectStore *objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"github.sqlite"];
    objectManager.objectStore = objectStore;
    objectManager.mappingProvider = [GithubObjectMappingProvider mappingProviderWithObjectStore:objectStore];
    
    // for some reason, ETags don't seem to work properly. RK doesn't fetch although the backend clearly has been updated.
    objectManager.client.cachePolicy = RKRequestCachePolicyLoadIfOffline | RKRequestCachePolicyTimeout; // | RKRequestCachePolicyEtag
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initRestKit];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Display login screen
    LoginController *loginController = [[LoginController alloc] init];
    loginController.delegate = self;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
    self.window.rootViewController = navigationController;
    
    
//    BrowseReposViewController *browseReposViewController = [[BrowseReposViewController alloc] init];
//    browseReposViewController.title = @"Repositories";
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:browseReposViewController];
//    self.window.rootViewController = navigationController;
//    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)performLogin:(LoginInfo *)loginInfo
{
    // Browse repos
    BrowseReposViewController *browseReposViewController = [[BrowseReposViewController alloc] init];

    browseReposViewController.loginInfo = loginInfo;
    
    [[[RKObjectManager sharedManager] client] setPassword:loginInfo.password];
    [[[RKObjectManager sharedManager] client] setUsername:loginInfo.login];
    
    [self.navigationController pushViewController:browseReposViewController animated:YES];
}

@end
