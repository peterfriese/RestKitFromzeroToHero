//
//  BrowseIssuesViewController.h
//  GitBrowser
//
//  Created by Peter Friese on 21.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseIssuesViewController : UITableViewController

@property (strong, nonatomic) NSString *repositoryUrl;

@property (strong, nonatomic) NSString *repouser;
@property (strong, nonatomic) NSString *repo;

@end
