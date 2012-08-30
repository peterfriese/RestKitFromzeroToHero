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

@property (strong, nonatomic) NSArray *repos;

@end

@implementation BrowseReposViewController

@synthesize loginInfo;
@synthesize repos = _repos;

- (NSString *)resourcePath
{
    return [NSString stringWithFormat:@"/users/%@/repos", loginInfo.login];
}


- (void)fetchData
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[self resourcePath] usingBlock:^(RKObjectLoader *loader) {
        [loader setOnDi dLoadObjects:^(NSArray *objects) {
            self.repos = objects;
            [self.tableView reloadData];
        }];
        [loader setOnDidFailWithError:^(NSError *error) {
            NSLog(@"Error loading repos for user %@: %@", loginInfo.login, error);
        }];
    }];
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.repos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    GithubRepo *repo = (GithubRepo *)[self.repos objectAtIndex:[indexPath row]];
    cell.textLabel.text = repo.name;
    cell.detailTextLabel.text = repo.open_issues;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GithubRepo *repo = (GithubRepo *)[self.repos objectAtIndex:[indexPath row]];
    NSString *baseUrl = [[[RKClient sharedClient] baseURL] absoluteString];
    NSString *resourcePath = [repo.url stringByReplacingOccurrencesOfString:baseUrl withString:@""];
    
    BrowseIssuesViewController *issuesViewController = [[BrowseIssuesViewController alloc] init];
    issuesViewController.repositoryUrl = resourcePath;
    issuesViewController.repo = repo.name;
    issuesViewController.repouser = loginInfo.login;
    [self.navigationController pushViewController:issuesViewController animated:YES];
}

@end
