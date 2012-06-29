//
//  GithubIssue.h
//  GitBrowser
//
//  Created by Peter Friese on 20.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GithubUser.h"

@interface GithubIssue : NSManagedObject

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *html_url;
@property (strong, nonatomic) NSNumber *number;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) GithubUser *user;
@property (strong, nonatomic) NSArray *labels;
@property (strong, nonatomic) GithubUser *assignee;
//@property (strong, nonatomic) GithubMilestone *milestone;
@property (strong, nonatomic) NSNumber *comments;
// @property (strong, nonatomic) GithubPullRequest *pull_request;
@property (strong, nonatomic) NSDate *closedAt;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;


// these are only used in order to construct the resource path, they won't be stored anywhere:
@property (strong, nonatomic) NSString *repouser;
@property (strong, nonatomic) NSString *repo;

- (NSString *)createdAtDate;

@end
