//
//  BrowseReposViewController.m
//  GitBrowser
//
//  Created by Peter Friese on 20.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import "BrowseReposViewController.h"
#import "GithubRepo.h"
#import "BrowseIssuesViewController.h"

@interface BrowseReposViewController ()
{
    RKObjectMapping *objectMapping;
    NSArray *repos;
}
@end

@implementation BrowseReposViewController

@synthesize loginInfo;

- (void)fetchData
{
    if ([[RKObjectManager sharedManager] isOnline]) {
        [self fetchDataFromRemote];
    }
    else {
        [self fetchDataFromDataStore];
    }
}

- (void)fetchDataFromDataStore
{
    repos = [GithubRepo allObjects];
    [self.tableView reloadData];    
}

- (void)fetchDataFromRemote
{
    RKObjectMapping *mapping = [[[RKObjectManager sharedManager] mappingProvider] objectMappingForClass:[GithubRepo class]];
    NSString *resourcePath = [NSString stringWithFormat:@"/users/%@/repos", loginInfo.login];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath 
                                                  objectMapping:mapping
                                                       delegate:self];    
}

- (void)reachabilityChanged:(NSNotification*)notification {
    RKReachabilityObserver* observer = (RKReachabilityObserver*)[notification object];
    
    if ([observer isNetworkReachable]) {
        if (![self.view isHidden]) {
            [self fetchDataFromRemote];            
        }
    } 
    else {
        if (![self.view isHidden]) {
            [self fetchDataFromDataStore];
        }
    }
}

- (void)registerForReachability
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:RKReachabilityDidChangeNotification
                                               object:nil];    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    repos = objects;
    [self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error;
{
    NSLog(@"Encountered an error: %@", error);
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Repositories";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self fetchData];    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self registerForReachability];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [repos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    GithubRepo *repo = (GithubRepo *)[repos objectAtIndex:[indexPath row]];
    cell.textLabel.text = repo.name;
    cell.detailTextLabel.text = repo.openIssues;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GithubRepo *repo = (GithubRepo *)[repos objectAtIndex:[indexPath row]];
    
    BrowseIssuesViewController *issuesViewController = [[BrowseIssuesViewController alloc] init];
    issuesViewController.repositoryUrl = repo.url;
    issuesViewController.repo = repo.name;
    issuesViewController.repouser = loginInfo.login;
    [self.navigationController pushViewController:issuesViewController animated:YES];
}

@end
