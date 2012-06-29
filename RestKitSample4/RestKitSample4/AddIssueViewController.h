//
//  AddIssueViewController.h
//  RestKitSample4
//
//  Created by Peter Friese on 23.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import "GithubIssue.h"

@protocol AddIssueViewControllerDelegate <NSObject>

- (void)didAddIssue:(GithubIssue *)issue;

@end

@interface AddIssueViewController : QuickDialogController<QuickDialogStyleProvider, RKObjectLoaderDelegate>

@property (strong, nonatomic) GithubIssue *issue;

@property (strong, nonatomic) NSString *repouser;
@property (strong, nonatomic) NSString *repo;

@property (assign, nonatomic) id<AddIssueViewControllerDelegate> delegate;


@end
