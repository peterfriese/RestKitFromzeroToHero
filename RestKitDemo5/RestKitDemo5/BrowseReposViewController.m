//
//  BrowseReposViewController.m
//  RestKitDemo5
//
//  Created by Peter Friese on 27.06.12.
//  Copyright (c) 2012 Peter Friese. All rights reserved.
//

#import "BrowseReposViewController.h"
#import "GithubRepo.h"
#import "BrowseIssuesViewController.h"

@interface BrowseReposViewController ()
@property (nonatomic, strong) RKFetchedResultsTableController *tableController;
@end

@implementation BrowseReposViewController

@synthesize loginInfo;

- (NSString *)resourcePath
{
    return [NSString stringWithFormat:@"/users/%@/repos", loginInfo.login];
}

@synthesize tableController;

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
    cellMapping.style = UITableViewCellStyleValue1;
    [cellMapping mapKeyPath:@"name" toAttribute:@"textLabel.text"];
    [cellMapping mapKeyPath:@"openIssues" toAttribute:@"detailTextLabel.text"];
    [cellMapping setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cellMapping.onSelectCellForObjectAtIndexPath = ^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
        GithubRepo *repo = (GithubRepo *)object;
        NSString *baseUrl = [[[RKClient sharedClient] baseURL] absoluteString];
        NSString *resourcePath = [repo.url stringByReplacingOccurrencesOfString:baseUrl withString:@""];
        
        BrowseIssuesViewController *issuesViewController = [[BrowseIssuesViewController alloc] init];
        issuesViewController.repositoryUrl = resourcePath;
        issuesViewController.repo = repo.name;
        issuesViewController.repouser = loginInfo.login;
        [self.navigationController pushViewController:issuesViewController animated:YES];
        
    };
    
    [tableController mapObjectsWithClass:[GithubRepo class] toTableCellsWithMapping:cellMapping];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [tableController loadTable];
}

@end
