//
//  AddIssueViewController.m
//  RestKitSample4
//
//  Created by Peter Friese on 23.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import "AddIssueViewController.h"
#import "GithubIssue.h"

@interface AddIssueViewController ()

- (QRootElement *)createForm;

@end

@implementation AddIssueViewController

@synthesize issue;
@synthesize repouser;
@synthesize repo;
@synthesize delegate;

-(id)init
{
    self = [super initWithRoot:[self createForm]];

    // cancel button
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                  target:self 
                                                                                  action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    // done button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                                  target:self 
                                                                                  action:@selector(onAddIssue:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (issue != nil) {
        [self.root bindToObject:issue];
    }    
}

- (void)setQuickDialogTableView:(QuickDialogTableView *)aQuickDialogTableView
{
    [super setQuickDialogTableView:aQuickDialogTableView];

    self.quickDialogTableView.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000];
    self.quickDialogTableView.bounces = NO;
    self.quickDialogTableView.styleProvider = self;
}

- (void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1.000];

    if ([element isKindOfClass:[QEntryElement class]] || [element isKindOfClass:[QButtonElement class]]){
        cell.textLabel.textColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
    }
}

- (void)onCancel
{
    // dismiss dialog
    [self dismissModalViewControllerAnimated:YES];    
}

- (void)onAddIssue:(QButtonElement *)buttonElement
{
    // fill in information from UI:
    if (issue == nil) {
        issue = [GithubIssue object];
    }
    [self.root fetchValueIntoObject:issue];

    // set username and repository, so the RestKit router can fill in this information in the resource URL:
    issue.repouser = repouser;
    issue.repo = repo;

    // post object to server:
    [[RKObjectManager sharedManager] postObject:issue delegate:self];

}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object
{
    if (self.delegate) {
        [delegate didAddIssue:object];
    }
}

- (void)objectLoaderDidFinishLoading:(RKObjectLoader *)objectLoader
{
    // dismiss dialog
    [self dismissModalViewControllerAnimated:YES];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error
{
    NSLog(@"Error sending issue: %@", [error description]);
}


- (QRootElement *)createForm
{
    QRootElement *root = [[QRootElement alloc] init];
    root.controllerName = @"AddIssueViewController";
    root.grouped = YES;
    root.title = @"Add Issue";

    QSection *main = [[QSection alloc] init];
    main.headerImage = @"logo";

    QEntryElement *title = [[QEntryElement alloc] init];
    title.title = @"Title";
    title.key = @"title";
    title.bind = @"textValue:title";
    [main addElement:title];

    QMultilineElement *body = [[QMultilineElement alloc] init];
    body.title = @"Body";
    body.key = @"body";
    body.bind = @"textValue:body";
    [main addElement:body];

    [root addSection:main];

    QSection *btSection = [[QSection alloc] init];
    QButtonElement *btAddIssue = [[QButtonElement alloc] init];
    btAddIssue.title = @"Add";
    btAddIssue.controllerAction = @"onAddIssue:";
    [btSection addElement:btAddIssue];

    [root addSection:btSection];
    btSection.footerImage = @"footer";
    
    return root;
}

@end
        