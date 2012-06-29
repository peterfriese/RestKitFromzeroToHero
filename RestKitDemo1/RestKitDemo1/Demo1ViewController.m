//
//  Demo1ViewController.m
//  RestKitDemo1
//
//  Created by Peter Friese on 25.06.12.
//  Copyright (c) 2012 Peter Friese. All rights reserved.
//

#import "Demo1ViewController.h"

@interface Demo1ViewController ()

@end

@implementation Demo1ViewController
@synthesize imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Perform regular request

- (IBAction)forkYouRegular
{
    self.imageView.image = nil;    
    [[RKClient sharedClient] get:@"https://github.com/fluidicon.png" delegate:self];
    
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    if (response.isSuccessful) {
        UIImage *image = [UIImage imageWithData:response.body];
        self.imageView.image = image;
    }    
}

#pragma mark - Perform request with blocks

- (IBAction)forkYouWithBlocks
{
    self.imageView.image = nil;
    [[RKClient sharedClient] get:@"http://github.com/fluidicon.png" usingBlock:^(RKRequest *request) {
        // next line allows you to leave the app 
        [request setBackgroundPolicy:RKRequestBackgroundPolicyContinue];
        [request setOnDidLoadResponse:^(RKResponse *response) {
            if (response.isSuccessful) {
                UIImage *image = [UIImage imageWithData:response.body];
                self.imageView.image = image;
            }
        }];
    }];
}

@end
