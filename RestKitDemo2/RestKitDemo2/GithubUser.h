//
//  GithubUser.h
//  GitBrowser
//
//  Created by Peter Friese on 20.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GithubUser : NSObject

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *blog;
@property (strong, nonatomic) NSString *followers;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *following;

@end
