//
//  User.h
//  GithubBrowser
//
//  Created by Peter Friese on 31.05.12.
//  Copyright (c) 2012 http://peterfriese.de. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GithubUser : NSObject

@property (strong, nonatomic) NSString *htmlUrl;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *location;
@property (nonatomic) BOOL hireable;
@property (strong, nonatomic) NSNumber *following;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSNumber *publicGists;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *gravatarId;
@property (strong, nonatomic) NSString *login;
@property (strong, nonatomic) NSNumber *publicRepos;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *followers;
@property (strong, nonatomic) NSString *blog;
@property (strong, nonatomic) NSString *avatarUrl;


@end
