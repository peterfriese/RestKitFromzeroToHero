//
//  ShowUserDetailsViewControllerViewController.m
//  RestKitDemo2
//
//  Created by Peter Friese on 25.06.12.
//  Copyright (c) 2012 Peter Friese. All rights reserved.
//

#import "ShowUserDetailsViewController.h"
#import "GithubUser.h"

@interface ShowUserDetailsViewController ()
{
    RKObjectMapping *objectMapping;
    RKObjectManager *objectManager;
}

- (QRootElement *)createUserDetailsForm;

@end

@implementation ShowUserDetailsViewController

@synthesize userName = _userName;

- (id)init
{
    self = [super initWithRoot:[self createUserDetailsForm]];
    return self;
}

- (void)setQuickDialogTableView:(QuickDialogTableView *)quickDialogTableView
{
    [super setQuickDialogTableView:quickDialogTableView];
    self.quickDialogTableView.backgroundView = nil;
    self.quickDialogTableView.backgroundColor = [UIColor whiteColor];
    self.quickDialogTableView.bounces = NO;
    self.view.backgroundColor = [UIColor greenColor];
    
}

- (RKObjectMapping *)mapping
{
    if (objectMapping == nil) {
        objectMapping = [RKObjectMapping mappingForClass:[GithubUser class]];
        [objectMapping mapKeyPath:@"id" toAttribute:@"id"];
        [objectMapping mapKeyPath:@"name" toAttribute:@"name"];
        [objectMapping mapKeyPath:@"company" toAttribute:@"company"];
        [objectMapping mapKeyPath:@"location" toAttribute:@"location"];
        [objectMapping mapKeyPath:@"blog" toAttribute:@"blog"];
        [objectMapping mapKeyPath:@"email" toAttribute:@"email"];
        
        [objectMapping mapKeyPath:@"following" toAttribute:@"following"];
        [objectMapping mapKeyPath:@"followers" toAttribute:@"followers"];
    }
    return objectMapping;
}

- (void)fetchData
{
    // fetch the specified user from Github
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/users/%@", self.userName] usingBlock:^(RKObjectLoader *loader) {
        [SVProgressHUD showWithStatus:@"Loading..."];
        [loader setObjectMapping:self.mapping];
        [loader setOnDidLoadObject:^(id object) {
            [self.root bindToObject:object];
            [self.quickDialogTableView reloadData];
            [SVProgressHUD dismiss];
        }];
        [loader setOnDidFailWithError:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Problem loading user"];
        }];
    }];    
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    [self fetchData];
}
 
/**
 * Build QuickDialog UI
 */
- (QRootElement *)createUserDetailsForm
{
    QRootElement *root = [[QRootElement alloc] init];
    root.controllerName = @"UserDetailsController";
    root.grouped = YES;
    root.title = @"User Detail";
    
    QSection *main = [[QSection alloc] init];
    main.headerImage = @"logo";
    
    QLabelElement *name = [[QLabelElement alloc] init];
    name.title = @"Name";
    name.key = @"name";
    name.bind = @"value:name";
    [main addElement:name];
    
    QLabelElement *company = [[QLabelElement alloc] init];
    company.title = @"Company";
    company.key = @"company";
    company.bind = @"value:company";
    [main addElement:company];
    
    QLabelElement *location = [[QLabelElement alloc] init];
    location.title = @"Location";
    location.key = @"location";
    location.bind = @"value:location";
    [main addElement:location];
    
    QLabelElement *blog = [[QLabelElement alloc] init];
    blog.title = @"Blog";
    blog.key = @"blog";
    blog.bind = @"value:blog";
    [main addElement:blog];
    
    QLabelElement *following = [[QLabelElement alloc] init];
    following.title = @"Following";
    following.key = @"following";
    following.bind = @"value:following";
    [main addElement:following];    
    
    QLabelElement *followers = [[QLabelElement alloc] init];
    followers.title = @"Followers";
    followers.key = @"followers";
    followers.bind = @"value:followers";
    [main addElement:followers];
    
    QLabelElement *email = [[QLabelElement alloc] init];
    email.title = @"E-mail";
    email.key = @"email";
    email.bind = @"value:email";
    [main addElement:email];
    
    [root addSection:main];
    
    return root;
}

@end
