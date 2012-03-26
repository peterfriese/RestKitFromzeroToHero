//
//  GithubIssue.m
//  GitBrowser
//
//  Created by Peter Friese on 20.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import "GithubIssue.h"

@implementation GithubIssue

@dynamic url;
@dynamic htmlUrl;
@dynamic number;
@dynamic state;
@dynamic title;
@dynamic body;
@dynamic user;
@dynamic labels;
@synthesize assignee;
//@dynamic milestone;
@dynamic comments;
// @dynamic pull_request;
@dynamic closedAt;
@dynamic createdAt;
@dynamic updatedAt;

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
