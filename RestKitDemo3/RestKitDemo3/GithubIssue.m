//
//  GithubIssue.m
//  GitBrowser
//
//  Created by Peter Friese on 20.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import "GithubIssue.h"

@implementation GithubIssue

@synthesize url;
@synthesize html_url;
@synthesize number;
@synthesize state;
@synthesize title;
@synthesize body;
@synthesize user;
@synthesize labels;
@synthesize assignee;
//@synthesize milestone;
@synthesize comments;
// @synthesize pull_request;
@synthesize closedAt;
@synthesize createdAt;
@synthesize updatedAt;

@synthesize repouser;
@synthesize repo;

- (NSString *)createdAtDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyy-MM-dd"];
    NSString *string = [formatter stringFromDate:self.createdAt];
    return string;
}

@end
