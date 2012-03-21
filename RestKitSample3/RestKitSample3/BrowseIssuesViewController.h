//
//  BrowseIssuesViewController.h
//  GitBrowser
//
//  Created by Peter Friese on 21.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseIssuesViewController : UITableViewController<RKObjectLoaderDelegate>

@property (strong, nonatomic) NSString *repositoryUrl;

@end
