//
//  BrowseReposViewController.h
//  GitBrowser
//
//  Created by Peter Friese on 20.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginInfo.h"

@interface BrowseReposViewController : UITableViewController<RKObjectLoaderDelegate>

@property (strong, nonatomic) LoginInfo *loginInfo;

@end
