//
//  UserDetialsController.m
//  GitBrowser
//
//  Created by Peter Friese on 20.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import "UserDetailsController.h"
#import "GithubUser.h"

@interface UserDetailsController ()
{
    RKObjectMapping *objectMapping;
    RKObjectManager *objectManager;
}

- (QRootElement *)createUserDetailsForm;

@end


@implementation UserDetailsController

@synthesize userName = _userName;
@synthesize protocol;

-(id)init
{
    self = [super initWithRoot:[self createUserDetailsForm]];
    return self;
}

- (RKObjectMapping *)mapping
{
    if (objectMapping == nil) {
        // define mapping from JSON / XML data structures to object structure
        objectMapping = [RKObjectMapping mappingForClass:[GithubUser class]];
        [objectMapping mapKeyPath:@"user.id" toAttribute:@"id"];
        [objectMapping mapKeyPath:@"user.name" toAttribute:@"name"];
        [objectMapping mapKeyPath:@"user.company" toAttribute:@"company"];
        [objectMapping mapKeyPath:@"user.location" toAttribute:@"location"];    
        [objectMapping mapKeyPath:@"user.blog" toAttribute:@"blog"];        
//        [objectMapping mapKeyPath:@"user.email" toAttribute:@"email"];           

        // some attributes have slightly different names in XML than in JSON
        if ([protocol isEqualToString:@"xml"]) {
            [objectMapping mapKeyPath:@"user.following-count" toAttribute:@"following"];   
            [objectMapping mapKeyPath:@"user.followers-count" toAttribute:@"followers"];               
        }
        else {
            [objectMapping mapKeyPath:@"user.following_count" toAttribute:@"following"];   
            [objectMapping mapKeyPath:@"user.followers_count" toAttribute:@"followers"];               
        }
    }
    return objectMapping;
}

- (RKObjectManager *)manager
{
    if (objectManager == nil) {
        objectManager = [RKObjectManager objectManagerWithBaseURL:@"https://github.com"];
    }
    return objectManager;
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    
    // fetch the specified user from Github
    [[self manager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"api/v2/%@/user/show/%@",
                                                                protocol, userName] 
                                                 objectMapping:self.mapping
                                                      delegate:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    // we're only interested in the first result (there should be only one reuslt, anyway)
    GithubUser *user = [objects objectAtIndex:0];
    
    // bind to QuickDialog UI
    [self.root bindToObject:user];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    NSLog(@"Encountered an error: %@", error);
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
