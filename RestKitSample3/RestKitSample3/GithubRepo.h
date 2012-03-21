//
//  GithubRepo.h
//  GitBrowser
//
//  Created by Peter Friese on 20.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GithubUser.h"

@interface GithubRepo : NSObject

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *html_url;
@property (strong, nonatomic) NSString *clone_url;
@property (strong, nonatomic) NSString *git_url;
@property (strong, nonatomic) NSString *ssh_url;
@property (strong, nonatomic) NSString *svn_url;
@property (strong, nonatomic) GithubUser *owner;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *homepage;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSString *private;
@property (strong, nonatomic) NSString *fork;
@property (strong, nonatomic) NSString *forks;
@property (strong, nonatomic) NSString *watchers;
@property (strong, nonatomic) NSString *size;
@property (strong, nonatomic) NSString *master_branch;
@property (strong, nonatomic) NSString *open_issues;
@property (strong, nonatomic) NSString *pushed_at;
@property (strong, nonatomic) NSString *created_at;

@end
