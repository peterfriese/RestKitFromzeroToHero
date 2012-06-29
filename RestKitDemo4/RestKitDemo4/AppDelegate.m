//
//  AppDelegate.m
//  RestKitDemo4
//
//  Created by Peter Friese on 26.06.12.
//  Copyright (c) 2012 Peter Friese. All rights reserved.
//

#import "AppDelegate.h"

#import "GithubUser.h"
#import "GithubIssue.h"
#import "GithubRepo.h"

#import "GithubObjectMappingProvider.h"

#import "LoginController.h"
#import "BrowseReposViewController.h"

@implementation AppDelegate

@synthesize navigationController = _navigationController;

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
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self initRestKit];
    
    // Display login screen
    LoginController *loginController = [[LoginController alloc] init];
    loginController.delegate = self;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
    self.window.rootViewController = self.navigationController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)performLogin:(LoginInfo *)loginInfo
{
    // Browse repos
    BrowseReposViewController *browseViewController = [[BrowseReposViewController alloc] init];
    browseViewController.loginInfo = loginInfo;
    
    [[[RKObjectManager sharedManager] client] setPassword:loginInfo.password];
    [[[RKObjectManager sharedManager] client] setUsername:loginInfo.login];
    
    // Set up tab bar
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    [tabbarController setViewControllers:[NSArray arrayWithObject: browseViewController]];
    
    [self.navigationController pushViewController:tabbarController animated:YES];
}

@end
