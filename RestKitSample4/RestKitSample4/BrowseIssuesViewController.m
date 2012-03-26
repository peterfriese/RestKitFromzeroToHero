//
//  BrowseIssuesViewController.m
//  GitBrowser
//
//  Created by Peter Friese on 21.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import "BrowseIssuesViewController.h"
#import "GithubIssue.h"
#import "AddIssueViewController.h"

@interface BrowseIssuesViewController ()
{
    NSArray *issues;
}
@end

@implementation BrowseIssuesViewController

@synthesize repositoryUrl;
@synthesize repouser;
@synthesize repo;

- (NSString *)resourcePath
{
    return [NSString stringWithFormat:@"%@/issues", repositoryUrl];
}

- (void)fetchData
{
    RKObjectMapping *mapping = [[[RKObjectManager sharedManager] mappingProvider] objectMappingForClass:[GithubIssue class]];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[self resourcePath] objectMapping:mapping delegate:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    issues = objects;
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
        self.title = @"Issues";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // "Add Issue" button
    UIBarButtonItem *addIssueButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddIssue)];
    self.navigationItem.rightBarButtonItem = addIssueButton;
    
    [self fetchData];
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
    return [issues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    GithubIssue *issue = (GithubIssue *)[issues objectAtIndex:[indexPath row]];
    cell.textLabel.text = issue.title;

    cell.detailTextLabel.text = [NSString stringWithFormat:@"Created by %@ on %@", issue.user.login, issue.createdAtDate];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Add issue button

- (void)onAddIssue
{
    AddIssueViewController *addIssueViewController = [[AddIssueViewController alloc] init];
    addIssueViewController.repouser = repouser;
    addIssueViewController.repo = repo;
    addIssueViewController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addIssueViewController];
    [self presentModalViewController:navigationController animated:YES];
}

-(void)didAddIssue:(GithubIssue *)issue{
    [self fetchData];
}
@end
