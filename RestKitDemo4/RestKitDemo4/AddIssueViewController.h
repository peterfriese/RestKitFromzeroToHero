//
//  AddIssueViewController.h
//  RestKitSample3
//
//  Created by Peter Friese on 23.03.12.
//  Copyright (c) 2012 Zühlke Group. All rights reserved.
//

@interface AddIssueViewController : QuickDialogController<QuickDialogStyleProvider>

@property (strong, nonatomic) NSString *repouser;
@property (strong, nonatomic) NSString *repo;


@end
