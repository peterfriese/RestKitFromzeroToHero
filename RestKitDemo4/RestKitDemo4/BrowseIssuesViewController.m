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

@property (strong, nonatomic) NSArray *issues;

@end

@implementation BrowseIssuesViewController

@synthesize issues = _issues;

@synthesize repositoryUrl;
@synthesize repouser;
@synthesize repo;

- (NSString *)resourcePath
{
    return [NSString stringWithFormat:@"%@/issues", repositoryUrl];
}

- (void)fetchData
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[self resourcePath] usingBlock:^(RKObjectLoader *loader) {
        [loader setOnDidLoadObjects:^(NSArray *objects) {
            self.issues = objects;
            [self.tableView reloadData];
        }];
        loader.onDidFailLoadWithError = ^(NSError *error) {
            NSLog(@"Encountered an error: %@", [error localizedDescription]);
        };
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // "Add Issue" button
    UIBarButtonItem *addIssueButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddIssue)];
    self.navigationItem.rightBarButtonItem = addIssueButton;
    
    [self fetchData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.issues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    GithubIssue *issue = (GithubIssue *)[self.issues objectAtIndex:[indexPath row]];
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
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addIssueViewController];
    [self presentModalViewController:navigationController animated:YES];
}

// TODO: reload data after adding issue!

@end
