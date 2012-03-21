//
//  Example1ViewController.m
//  GitBrowser
//
//  Created by Peter Friese on 19.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import "Example1ViewController.h"

@interface Example1ViewController ()

@end

@implementation Example1ViewController

@synthesize imageView;

- (IBAction)forkYou:(id)sender {
    [[RKClient sharedClient] get:@"https://github.com/fluidicon.png" delegate:self];
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    if ([response isOK]) {
        UIImage *image = [UIImage imageWithData:[response body]];
        self.imageView.image = image;
    }
}

@end
