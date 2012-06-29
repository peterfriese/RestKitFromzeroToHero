//
//  BrowseIssuesViewController.h
//  RestKitDemo5
//
//  Created by Peter Friese on 28.06.12.
//  Copyright (c) 2012 Peter Friese. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseIssuesViewController : UITableViewController

@property (strong, nonatomic) NSString *repositoryUrl;

@property (strong, nonatomic) NSString *repouser;
@property (strong, nonatomic) NSString *repo;

@end
