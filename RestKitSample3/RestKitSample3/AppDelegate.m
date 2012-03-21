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
@synthesize tabbarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [RKObjectManager objectManagerWithBaseURL:@"https://api.github.com"];
    
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
    
    RKObjectMapping *issueMapping = [RKObjectMapping mappingForClass:[GithubIssue class]];
    [issueMapping mapKeyPath:@"url" toAttribute:@"url"];
    [issueMapping mapKeyPath:@"number" toAttribute:@"number"];
    [issueMapping mapKeyPath:@"state" toAttribute:@"state"];
    [issueMapping mapKeyPath:@"title" toAttribute:@"title"];
    [issueMapping mapKeyPath:@"body" toAttribute:@"body"];
    [issueMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
    [[[RKObjectManager sharedManager] mappingProvider] addObjectMapping:issueMapping];
    
    RKObjectMapping *repoMapping = [RKObjectMapping mappingForClass:[GithubRepo class]];
    [repoMapping mapKeyPath:@"url" toAttribute:@"url"];
    [repoMapping mapKeyPath:@"name" toAttribute:@"name"];
    [repoMapping mapKeyPath:@"description" toAttribute:@"description"];
    [repoMapping mapKeyPath:@"private" toAttribute:@"private"];
    [repoMapping mapKeyPath:@"open_issues" toAttribute:@"open_issues"];
    [[[RKObjectManager sharedManager] mappingProvider] addObjectMapping:repoMapping];
    
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
