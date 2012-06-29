//
//  LoginController.h
//  GitBrowser
//
//  Created by Peter Friese on 23.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import "LoginInfo.h"

@protocol LoginHandlerDelegate <NSObject>

- (void)performLogin:(LoginInfo *)loginInfo;

@end

@interface LoginController: QuickDialogController <QuickDialogStyleProvider, QuickDialogEntryElementDelegate> 

@property (assign, nonatomic) id<LoginHandlerDelegate>delegate;

@end