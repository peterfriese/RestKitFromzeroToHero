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

- (RKObjectMapping *)mapping
{
    if (objectMapping == nil) {
        // define mapping from JSON data structure to object structure
        objectMapping = [RKObjectMapping mappingForClass:[GithubRepo class]];
        [objectMapping mapKeyPath:@"url" toAttribute:@"url"];
        [objectMapping mapKeyPath:@"name" toAttribute:@"name"];
        [objectMapping mapKeyPath:@"description" toAttribute:@"description"];
        [objectMapping mapKeyPath:@"private" toAttribute:@"private"];
        [objectMapping mapKeyPath:@"open_issues" toAttribute:@"open_issues"];
    }
    return objectMapping;    
}

- (void)fetchData
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/users/peterfriese/repos" 
                                                  objectMapping:[self mapping] 
                                                       delegate:self];
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
    cell.detailTextLabel.text = repo.open_issues;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GithubRepo *repo = (GithubRepo *)[repos objectAtIndex:[indexPath row]];
    
    BrowseIssuesViewController *issuesViewController = [[BrowseIssuesViewController alloc] init];
    issuesViewController.repositoryUrl = repo.url;
    [self.navigationController pushViewController:issuesViewController animated:YES];
}

@end
