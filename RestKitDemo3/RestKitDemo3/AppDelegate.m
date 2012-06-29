//
//  AppDelegate.m
//  RestKitDemo3
//
//  Created by Peter Friese on 26.06.12.
//  Copyright (c) 2012 Peter Friese. All rights reserved.
//

#import "AppDelegate.h"

#import "GithubUser.h"
#import "GithubIssue.h"
#import "GithubRepo.h"

#import "LoginController.h"
#import "BrowseReposViewController.h"

@implementation AppDelegate

@synthesize navigationController = _navigationController;

- (void)initRestKit
{
    // Init RestKit
    // ------------------------------    
    [RKObjectManager objectManagerWithBaseURLString:@"https://api.github.com"];
    [[[RKObjectManager sharedManager] client] setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forHTTPHeaderField:@"X-UDID"];
    
    [[[RKObjectManager sharedManager] client] setAuthenticationType:RKRequestAuthenticationTypeHTTPBasic];
    [[RKObjectManager sharedManager] setSerializationMIMEType:RKMIMETypeJSON];
    [[RKObjectManager sharedManager] setAcceptMIMEType:RKMIMETypeJSON];
    
    // Use cache if offline
    [[[RKObjectManager sharedManager] client] setCachePolicy:RKRequestCachePolicyLoadIfOffline];
    
    // create mapping for GithubUser
    // ------------------------------
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[GithubUser class]];
    [userMapping mapKeyPath:@"id" toAttribute:@"id"];
    [userMapping mapKeyPath:@"login" toAttribute:@"login"];    
    [userMapping mapKeyPath:@"name" toAttribute:@"name"];
    [userMapping mapKeyPath:@"company" toAttribute:@"company"];
    [userMapping mapKeyPath:@"location" toAttribute:@"location"];    
    [userMapping mapKeyPath:@"blog" toAttribute:@"blog"];
    [userMapping mapKeyPath:@"email" toAttribute:@"email"];
    [userMapping mapKeyPath:@"following" toAttribute:@"following"];   
    [userMapping mapKeyPath:@"followers" toAttribute:@"followers"];
    
    // create mapping for GithubIssue
    // ------------------------------
    RKObjectMapping *issueMapping = [RKObjectMapping mappingForClass:[GithubIssue class]];
    [issueMapping mapKeyPath:@"url" toAttribute:@"url"];
    [issueMapping mapKeyPath:@"number" toAttribute:@"number"];
    [issueMapping mapKeyPath:@"state" toAttribute:@"state"];
    [issueMapping mapKeyPath:@"title" toAttribute:@"title"];
    [issueMapping mapKeyPath:@"body" toAttribute:@"body"];
    [issueMapping mapKeyPath:@"created_at" toAttribute:@"createdAt"];
    // GithubIssue relationships
    [issueMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
    [[[RKObjectManager sharedManager] mappingProvider] setObjectMapping:issueMapping forResourcePathPattern:@"/repos/:user/:repo/issues"];
    
    // add serialization mapping and route for GithubIssue
    RKObjectMapping *issueSerializationMapping = [issueMapping inverseMapping];
    [[[RKObjectManager sharedManager] mappingProvider] setSerializationMapping:issueSerializationMapping forClass:[GithubIssue class]];
    [[[RKObjectManager sharedManager] router] routeClass:[GithubIssue class] toResourcePath:@"/repos/:repouser/:repo/issues/:number"];
    [[[RKObjectManager sharedManager] router] routeClass:[GithubIssue class] toResourcePath:@"/repos/:repouser/:repo/issues" forMethod:RKRequestMethodPOST ];

    // create mapping for GithubRepo
    // ------------------------------    
    RKObjectMapping *repoMapping = [RKObjectMapping mappingForClass:[GithubRepo class]];
    [repoMapping mapKeyPath:@"url" toAttribute:@"url"];
    [repoMapping mapKeyPath:@"name" toAttribute:@"name"];
    [repoMapping mapKeyPath:@"description" toAttribute:@"description"];
    [repoMapping mapKeyPath:@"private" toAttribute:@"private"];
    [repoMapping mapKeyPath:@"open_issues" toAttribute:@"open_issues"];
    [[[RKObjectManager sharedManager] mappingProvider] setObjectMapping:repoMapping forResourcePathPattern:@"/users/:user/repos"];
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
