//
//  GithubRepo.h
//  GitBrowser
//
//  Created by Peter Friese on 20.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GithubUser.h"

@interface GithubRepo : NSManagedObject

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *htmlUrl;
@property (strong, nonatomic) NSString *cloneUrl;
@property (strong, nonatomic) NSString *gitUrl;
@property (strong, nonatomic) NSString *sshUrl;
@property (strong, nonatomic) NSString *svnUrl;
@property (strong, nonatomic) GithubUser *owner;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *descr;
@property (strong, nonatomic) NSString *homepage;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSString *private;
@property (strong, nonatomic) NSString *fork;
@property (strong, nonatomic) NSString *forks;
@property (strong, nonatomic) NSString *watchers;
@property (strong, nonatomic) NSString *size;
@property (strong, nonatomic) NSString *masterBranch;
@property (strong, nonatomic) NSString *openIssues;
@property (strong, nonatomic) NSDate *pushedAt;
@property (strong, nonatomic) NSDate *createdAt;

@end
