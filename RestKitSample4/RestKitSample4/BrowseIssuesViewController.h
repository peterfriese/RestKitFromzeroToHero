//
//  BrowseIssuesViewController.h
//  GitBrowser
//
//  Created by Peter Friese on 21.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddIssueViewController.h"

@interface BrowseIssuesViewController : UITableViewController<RKObjectLoaderDelegate, AddIssueViewControllerDelegate>

@property (strong, nonatomic) NSString *repositoryUrl;

@property (strong, nonatomic) NSString *repouser;
@property (strong, nonatomic) NSString *repo;

@end
