//
//  LoginController.m
//  GitBrowser
//
//  Created by Peter Friese on 23.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import "LoginController.h"
#import "LoginInfo.h"

@interface LoginController ()

- (QRootElement *)createLoginForm;
- (void)onLogin:(QButtonElement *)buttonElement;

@end

@implementation LoginController

@synthesize delegate;

-(id)init
{
    self = [super initWithRoot:[self createLoginForm]];
    return self;
}


- (void)setQuickDialogTableView:(QuickDialogTableView *)aQuickDialogTableView 
{
    [super setQuickDialogTableView:aQuickDialogTableView];

    self.quickDialogTableView.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000];
    self.quickDialogTableView.bounces = NO;
    self.quickDialogTableView.styleProvider = self;

    ((QEntryElement *)[self.root elementWithKey:@"login"]).delegate = self;
}

- (void)onLogin:(QButtonElement *)buttonElement 
{
    LoginInfo *info = [[LoginInfo alloc] init];
    [self.root fetchValueIntoObject:info];

    if (delegate) {
        [delegate performLogin:info];
    }
}

- (void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1.000];

    if ([element isKindOfClass:[QEntryElement class]] || [element isKindOfClass:[QButtonElement class]]){
        cell.textLabel.textColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
    }   
}

- (QRootElement *)createLoginForm 
{
    QRootElement *root = [[QRootElement alloc] init];
    root.controllerName = @"LoginController";
    root.grouped = YES;
    root.title = @"Login";

    QSection *main = [[QSection alloc] init];
    main.headerImage = @"logo";

    QEntryElement *login = [[QEntryElement alloc] init];
    login.title = @"Username";
    login.key = @"login";
    login.hiddenToolbar = YES;
    login.placeholder = @"octocat";
    login.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [main addElement:login];

    QEntryElement *password = [[QEntryElement alloc] init];
    password.title = @"Password";
    password.key = @"password";
    password.secureTextEntry = YES;
    password.hiddenToolbar = YES;
    password.placeholder = @"your password";
    [main addElement:password];

    [root addSection:main];

    QSection *btSection = [[QSection alloc] init];
    QButtonElement *btLogin = [[QButtonElement alloc] init];
    btLogin.title = @"Login";
    btLogin.controllerAction = @"onLogin:";
    [btSection addElement:btLogin];

    [root addSection:btSection];

    btSection.footerImage = @"footer";

    return root;
}

@end