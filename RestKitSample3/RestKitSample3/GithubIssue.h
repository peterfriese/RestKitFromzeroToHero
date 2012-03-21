//
//  GithubIssue.h
//  GitBrowser
//
//  Created by Peter Friese on 20.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GithubUser.h"

@interface GithubIssue : NSObject

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
@property (strong, nonatomic) NSDate *closed_at;
@property (strong, nonatomic) NSDate *created_at;
@property (strong, nonatomic) NSDate *updated_at;

@end
