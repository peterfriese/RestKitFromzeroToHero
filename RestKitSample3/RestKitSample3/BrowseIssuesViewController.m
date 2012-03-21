//
//  BrowseIssuesViewController.m
//  GitBrowser
//
//  Created by Peter Friese on 21.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import "BrowseIssuesViewController.h"
#import "GithubIssue.h"

@interface BrowseIssuesViewController ()
{
    RKObjectMapping *objectMapping;
    NSArray *issues;
}
@end

@implementation BrowseIssuesViewController

@synthesize repositoryUrl;

- (RKObjectMapping *)mapping
{
    if (objectMapping == nil) {
        // define mapping from JSON data structure to object structure
        objectMapping = [RKObjectMapping mappingForClass:[GithubIssue class]];
        [objectMapping mapKeyPath:@"url" toAttribute:@"url"];
        [objectMapping mapKeyPath:@"number" toAttribute:@"number"];
        [objectMapping mapKeyPath:@"state" toAttribute:@"state"];
        [objectMapping mapKeyPath:@"title" toAttribute:@"title"];
        [objectMapping mapKeyPath:@"body" toAttribute:@"body"];
    }
    return objectMapping;    
}

- (NSString *)resourcePath
{
    return [NSString stringWithFormat:@"%@/issues", repositoryUrl];
}

- (void)fetchData
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[self resourcePath]
                                                 objectMapping:[self mapping] 
                                                      delegate:self];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    GithubIssue *issue = (GithubIssue *)[issues objectAtIndex:[indexPath row]];
    cell.textLabel.text = issue.title;
    
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

@end
