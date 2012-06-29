//
//  AppDelegate.m
//  RestKitSample4
//
//  Created by Peter Friese on 21.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
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

    if (NO) {
        RKLogConfigureByName("RestKit", RKLogLevelTrace);
        RKLogConfigureByName("RestKit/​Network", RKLogLevelDebug);
        RKLogConfigureByName("RestKit/​ObjectMapping", RKLogLevelDebug);
        RKLogConfigureByName("RestKit/​Network/Queue", RKLogLevelDebug);
        RKLogSetAppLoggingLevel(RKLogLevelTrace);        
    }

    // set up object manager
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:@"https://api.github.com"];
    
    // we want to send and receive JSON
    objectManager.serializationMIMEType = RKMIMETypeJSON;
    objectManager.acceptMIMEType = RKMIMETypeJSON;
    
    // use basic HTTP authentication for the time being
    objectManager.client.authenticationType = RKRequestAuthenticationTypeHTTPBasic;
    
    // show network indicator in status bar
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    
    // set up backing data store
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"gihub.sqlite"];
    
    
    // TODO: extract maaping to mappingprovider?
    RKManagedObjectMapping *userMapping = [RKManagedObjectMapping mappingForClass:[GithubUser class]];
    userMapping.primaryKeyAttribute = @"id";
    [userMapping mapKeyPath:@"id" toAttribute:@"id"];
    [userMapping mapKeyPath:@"login" toAttribute:@"login"];
    [userMapping mapKeyPath:@"name" toAttribute:@"name"];
    [userMapping mapKeyPath:@"company" toAttribute:@"company"];
    [userMapping mapKeyPath:@"location" toAttribute:@"location"];
    [userMapping mapKeyPath:@"blog" toAttribute:@"blog"];
    [userMapping mapKeyPath:@"email" toAttribute:@"email"];
    [userMapping mapKeyPath:@"following" toAttribute:@"following"];
    [userMapping mapKeyPath:@"followers" toAttribute:@"followers"];
    [[[RKObjectManager sharedManager] mappingProvider] addObjectMapping:userMapping];
    [[[RKObjectManager sharedManager] mappingProvider] setMapping:userMapping forKeyPath:@""]; // <-- just to check if we can register more than one class per path.


    // create mapping for GithubIssue
    RKManagedObjectMapping *issueMapping = [RKManagedObjectMapping mappingForClass:[GithubIssue class]];
    issueMapping.primaryKeyAttribute = @"url";
    [issueMapping mapKeyPath:@"url" toAttribute:@"url"];
    [issueMapping mapKeyPath:@"number" toAttribute:@"number"];
    [issueMapping mapKeyPath:@"state" toAttribute:@"state"];
    [issueMapping mapKeyPath:@"title" toAttribute:@"title"];
    [issueMapping mapKeyPath:@"body" toAttribute:@"body"];
    [issueMapping mapKeyPath:@"created_at" toAttribute:@"createdAt"];
    [issueMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];

    // add mapping for GithubIssue
    [[[RKObjectManager sharedManager] mappingProvider] setObjectMapping:issueMapping forKeyPath:@""];

    // add serialization mapping and route for GithubIssue
    RKObjectMapping *issueSerializationMapping = [issueMapping inverseMapping];
    [[[RKObjectManager sharedManager] mappingProvider] setSerializationMapping:issueSerializationMapping forClass:[GithubIssue class]];
    [[[RKObjectManager sharedManager] router] routeClass:[GithubIssue class] toResourcePath:@"/repos/:repouser/:repo/issues/:number"];
    [[[RKObjectManager sharedManager] router] routeClass:[GithubIssue class] toResourcePath:@"/repos/:repouser/:repo/issues" forMethod:RKRequestMethodPOST ];

    RKManagedObjectMapping *repoMapping = [RKManagedObjectMapping mappingForClass:[GithubRepo class]];
    repoMapping.primaryKeyAttribute = @"url";
    [repoMapping mapKeyPath:@"url" toAttribute:@"url"];
    [repoMapping mapKeyPath:@"name" toAttribute:@"name"];
    [repoMapping mapKeyPath:@"description" toAttribute:@"descr"];
    [repoMapping mapKeyPath:@"private" toAttribute:@"private"];
    [repoMapping mapKeyPath:@"open_issues" toAttribute:@"openIssues"];
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
    BrowseReposViewController *browseReposViewController = [[BrowseReposViewController alloc] init];
    browseReposViewController.loginInfo = loginInfo;

    [[[RKObjectManager sharedManager] client] setPassword:loginInfo.password];
    [[[RKObjectManager sharedManager] client] setUsername:loginInfo.login];

    [navigationController pushViewController:browseReposViewController animated:YES];
}

@end
