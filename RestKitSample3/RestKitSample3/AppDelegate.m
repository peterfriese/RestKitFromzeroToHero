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
#import "GithubRepo.h"
#import "GithubIssue.h"
#import "GithubUser.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
//    RKLogConfigureByName("RestKit", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/​Network", RKLogLevelDebug); 
//    RKLogConfigureByName("RestKit/​ObjectMapping", RKLogLevelDebug); 
//    RKLogConfigureByName("RestKit/​Network/Queue", RKLogLevelDebug); 
    
//    RKLogSetAppLoggingLevel(RKLogLevelTrace);
    
    [RKClient clientWithBaseURL:@"https://api.github.com"];
    [[RKClient sharedClient] setAuthenticationType:RKRequestAuthenticationTypeHTTPBasic];
    
    [RKObjectManager objectManagerWithBaseURL:@"https://api.github.com"];
    [[RKObjectManager sharedManager] setClient:[RKClient sharedClient]];
    [[RKObjectManager sharedManager] setSerializationMIMEType:RKMIMETypeJSON];
    [[RKObjectManager sharedManager] setAcceptMIMEType:RKMIMETypeJSON];
    
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[GithubUser class]];
    [userMapping mapKeyPath:@"id" toAttribute:@"id"];
    [userMapping mapKeyPath:@"login" toAttribute:@"login"];    
    [userMapping mapKeyPath:@"name" toAttribute:@"name"];
    [userMapping mapKeyPath:@"company" toAttribute:@"company"];
    [userMapping mapKeyPath:@"location" toAttribute:@"location"];    
    [userMapping mapKeyPath:@"blog" toAttribute:@"blog"];
    //        [objectMapping mapKeyPath:@"user.email" toAttribute:@"email"];
    [userMapping mapKeyPath:@"following" toAttribute:@"following"];   
    [userMapping mapKeyPath:@"followers" toAttribute:@"followers"];
    [[[RKObjectManager sharedManager] mappingProvider] addObjectMapping:userMapping];
    [[[RKObjectManager sharedManager] mappingProvider] setMapping:userMapping forKeyPath:@""]; // <-- just to check if we can register more than one class per path.
    
    
    // create mapping for GithubIssue
    RKObjectMapping *issueMapping = [RKObjectMapping mappingForClass:[GithubIssue class]];
    [issueMapping mapKeyPath:@"url" toAttribute:@"url"];
    [issueMapping mapKeyPath:@"number" toAttribute:@"number"];
    [issueMapping mapKeyPath:@"state" toAttribute:@"state"];
    [issueMapping mapKeyPath:@"title" toAttribute:@"title"];
    [issueMapping mapKeyPath:@"body" toAttribute:@"body"];
    [issueMapping mapKeyPath:@"created_at" toAttribute:@"createdAt"];
    [issueMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
    
    // add mapping for GithubIssue
//    [[[RKObjectManager sharedManager] mappingProvider] addObjectMapping:issueMapping];
    [[[RKObjectManager sharedManager] mappingProvider] setObjectMapping:issueMapping forKeyPath:@""];

    // add serialization mapping and route for GithubIssue
    RKObjectMapping *issueSerializationMapping = [issueMapping inverseMapping];
    [[[RKObjectManager sharedManager] mappingProvider] setSerializationMapping:issueSerializationMapping forClass:[GithubIssue class]];
    [[[RKObjectManager sharedManager] router] routeClass:[GithubIssue class] toResourcePath:@"/repos/:repouser/:repo/issues/:number"];
    [[[RKObjectManager sharedManager] router] routeClass:[GithubIssue class] toResourcePath:@"/repos/:repouser/:repo/issues" forMethod:RKRequestMethodPOST ];
    
    RKObjectMapping *repoMapping = [RKObjectMapping mappingForClass:[GithubRepo class]];
    [repoMapping mapKeyPath:@"url" toAttribute:@"url"];
    [repoMapping mapKeyPath:@"name" toAttribute:@"name"];
    [repoMapping mapKeyPath:@"description" toAttribute:@"description"];
    [repoMapping mapKeyPath:@"private" toAttribute:@"private"];
    [repoMapping mapKeyPath:@"open_issues" toAttribute:@"open_issues"];
    [[[RKObjectManager sharedManager] mappingProvider] addObjectMapping:repoMapping];
    
    // Login
    LoginController *loginController = [[LoginController alloc] init];
    loginController.delegate = self;
    navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
    
    [self.window addSubview:navigationController.view];
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
    [tabbarController setViewControllers:[NSArray arrayWithObjects:
                                          browseViewController, 
                                          nil]];
    
    [navigationController pushViewController:tabbarController animated:YES];
}

@end
