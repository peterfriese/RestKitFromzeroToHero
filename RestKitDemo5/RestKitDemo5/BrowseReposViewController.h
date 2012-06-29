//
//  BrowseReposViewController.h
//  RestKitDemo5
//
//  Created by Peter Friese on 27.06.12.
//  Copyright (c) 2012 Peter Friese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginInfo.h"

@interface BrowseReposViewController : UITableViewController

@property (strong, nonatomic) LoginInfo *loginInfo;

@end
