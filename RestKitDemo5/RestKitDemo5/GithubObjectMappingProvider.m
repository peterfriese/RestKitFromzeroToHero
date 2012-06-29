//
//  GithubObjectMappingProvider.m
//  RestKitDemo4
//
//  Created by Peter Friese on 27.06.12.
//  Copyright (c) 2012 Peter Friese. All rights reserved.
//

#import "GithubObjectMappingProvider.h"

#import "GithubUser.h"
#import "GithubIssue.h"
#import "GithubRepo.h"

@implementation GithubObjectMappingProvider

@synthesize objectStore;

+ (id)mappingProviderWithObjectStore:(RKManagedObjectStore *)objectStore
{
    return [[self alloc] initWithObjectStore:objectStore];    
}

- (id)initWithObjectStore:(RKManagedObjectStore *)theObjectStore
{
    self = [super init];
    if (self) {
        
        self.objectStore = theObjectStore;
        
        // create mapping for GithubUser
        // ------------------------------
        RKManagedObjectMapping *userMapping = [RKManagedObjectMapping mappingForClass:[GithubUser class] inManagedObjectStore:objectStore];
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
        
        // create mapping for GithubIssue
        // ------------------------------
        RKManagedObjectMapping *issueMapping = [RKManagedObjectMapping mappingForClass:[GithubIssue class] inManagedObjectStore:objectStore];
        issueMapping.primaryKeyAttribute = @"id";
        [issueMapping mapKeyPath:@"id" toAttribute:@"id"];
        [issueMapping mapKeyPath:@"url" toAttribute:@"url"];
        [issueMapping mapKeyPath:@"number" toAttribute:@"number"];
        [issueMapping mapKeyPath:@"state" toAttribute:@"state"];
        [issueMapping mapKeyPath:@"title" toAttribute:@"title"];
        [issueMapping mapKeyPath:@"body" toAttribute:@"body"];
        [issueMapping mapKeyPath:@"created_at" toAttribute:@"createdAt"];
        // GithubIssue relationships
        [issueMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
        
        
//        [self setObjectMapping:issueMapping forResourcePathPattern:@"/repos/:user/:repo/issues"];
        
        // TODO:
        //  Need to make sure we only fetch issues for the respective repo at /repos/:user/:repo/issues.
        //  We somehow need to store a relationship between the repo and the issue. Not yet sure where to
        //  get that from, as it is not in the JSON we receive. For the time being, we won't use NSFetchRequest here,
        //  which basically makes this part of the app non-offlineable.
        [self setObjectMapping:issueMapping forResourcePathPattern:@"/repos/:user/:repo/issues" withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
            // extract username from resource path
            NSDictionary *arguments = nil;
            RKPathMatcher *matcher = [RKPathMatcher matcherWithPath:resourcePath];
            [matcher matchesPattern:@"/repos/:user/:repo/issues" tokenizeQueryStrings:YES parsedArguments:&arguments];
            NSString *user = [arguments objectForKey:@"user"];
            NSString *repo = [arguments objectForKey:@"repo"];
            NSURL *url = [[[RKClient sharedClient] baseURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"/repos/%@/%@/issues", user, repo]];

            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url contains [cd] %@", [url absoluteString]];
            NSFetchRequest *request = [GithubIssue fetchRequest];
            [request setPredicate:predicate];

            return request;
        }];
        
        // add serialization mapping and route for GithubIssue
        RKObjectMapping *issueSerializationMapping = [issueMapping inverseMapping];
        [self setSerializationMapping:issueSerializationMapping forClass:[GithubIssue class]];
        [[[RKObjectManager sharedManager] router] routeClass:[GithubIssue class] toResourcePath:@"/repos/:repouser/:repo/issues/:number"];
        [[[RKObjectManager sharedManager] router] routeClass:[GithubIssue class] toResourcePath:@"/repos/:repouser/:repo/issues" forMethod:RKRequestMethodPOST ];
        
        // create mapping for GithubRepo
        // ------------------------------    
        RKManagedObjectMapping *repoMapping = [RKManagedObjectMapping mappingForClass:[GithubRepo class] inManagedObjectStore:objectStore];
        repoMapping.primaryKeyAttribute = @"id";
        [repoMapping mapKeyPath:@"id" toAttribute:@"id"];
        [repoMapping mapKeyPath:@"url" toAttribute:@"url"];
        [repoMapping mapKeyPath:@"name" toAttribute:@"name"];
        [repoMapping mapKeyPath:@"description" toAttribute:@"descr"];
        [repoMapping mapKeyPath:@"private" toAttribute:@"private"];
        [repoMapping mapKeyPath:@"open_issues" toAttribute:@"openIssues"];
        [repoMapping mapKeyPath:@"owner" toRelationship:@"owner" withMapping:userMapping];
        [self setObjectMapping:repoMapping forResourcePathPattern:@"/users/:user/repos" withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
            
            // extract username from resource path
            NSDictionary *arguments = nil;
            RKPathMatcher *matcher = [RKPathMatcher matcherWithPath:resourcePath];
            [matcher matchesPattern:@"/users/:user/repos" tokenizeQueryStrings:YES parsedArguments:&arguments];
            NSString *user = [arguments objectForKey:@"user"];
            
            NSFetchRequest *request = [GithubRepo fetchRequest];
            [request setPredicate:[NSPredicate predicateWithFormat:@"owner.login == %@", user]];
            
            return request;
        }];
        
    }
    return self;
}


@end
