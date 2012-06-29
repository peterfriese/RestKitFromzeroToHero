//
//  BrowseIssuesViewController.m
//  RestKitDemo5
//
//  Created by Peter Friese on 28.06.12.
//  Copyright (c) 2012 Peter Friese. All rights reserved.
//

#import "BrowseIssuesViewController.h"
#import "GithubIssue.h"

@interface BrowseIssuesViewController ()
@property (strong, nonatomic) NSArray *issues;
@property (nonatomic, strong) RKFetchedResultsTableController *tableController;
@end

@implementation BrowseIssuesViewController

@synthesize tableController;
@synthesize issues = _issues;

@synthesize repositoryUrl;
@synthesize repouser;
@synthesize repo;

- (NSString *)resourcePath
{
    return [NSString stringWithFormat:@"%@/issues", repositoryUrl];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create and configure a RK table controller
    self.tableController = [[RKObjectManager sharedManager] fetchedResultsTableControllerForTableViewController:self];
    self.tableController.autoRefreshFromNetwork = YES;
    self.tableController.pullToRefreshEnabled = YES;
    self.tableController.resourcePath = [self resourcePath];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    self.tableController.sortDescriptors = [NSArray arrayWithObject:descriptor];
    
    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.style = UITableViewCellStyleSubtitle;
    [cellMapping mapKeyPath:@"title" toAttribute:@"textLabel.text"];
    [cellMapping mapKeyPath:@"createdAtDate" toAttribute:@"detailTextLabel.text"];
    
    [tableController mapObjectsWithClass:[GithubIssue class] toTableCellsWithMapping:cellMapping];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [tableController loadTable];
}

@end
