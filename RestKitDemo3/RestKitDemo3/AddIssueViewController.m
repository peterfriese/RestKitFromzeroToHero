//
//  AddIssueViewController.m
//  RestKitSample3
//
//  Created by Peter Friese on 23.03.12.
//  Copyright (c) 2012 Zühlke Group. All rights reserved.
//

#import "AddIssueViewController.h"
#import "GithubIssue.h"

@interface AddIssueViewController ()

- (QRootElement *)createForm;

@end

@implementation AddIssueViewController

@synthesize repouser;
@synthesize repo;

-(id)init
{
    self = [super initWithRoot:[self createForm]];
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                           target:self
                                                                                           action:@selector(onCancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                          target:self
                                                                                          action:@selector(onDone)];
}

- (void)onCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onDone
{
    // fill in information from UI:
    GithubIssue *issue = [[GithubIssue alloc] init];
    [self.root fetchValueIntoObject:issue];
    
    // set username and repository, so the RestKit router can fill in this information in the resource URL:
    issue.repouser = repouser;
    issue.repo = repo;
    
    // post object to server:
    [[RKObjectManager sharedManager] postObject:issue usingBlock:^(RKObjectLoader *loader){
        loader.onDidLoadResponse = ^(RKResponse *response) {
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        loader.onDidFailWithError = ^(NSError  *error) {
            NSLog(@"An error occurred: %@", [error localizedDescription]);
        };
    }];
    
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
    [main addElement:title];
    
    QMultilineElement *body = [[QMultilineElement alloc] init];
    body.title = @"Body";
    body.key = @"body";
    [main addElement:body];
    
    [root addSection:main];
    
//    QSection *btSection = [[QSection alloc] init];
//    QButtonElement *btAddIssue = [[QButtonElement alloc] init];
//    btAddIssue.title = @"Add";
//    btAddIssue.controllerAction = @"onAddIssue:";
//    [btSection addElement:btAddIssue];
    
//    [root addSection:btSection];
//    btSection.footerImage = @"footer";
    
    return root;
}

@end
