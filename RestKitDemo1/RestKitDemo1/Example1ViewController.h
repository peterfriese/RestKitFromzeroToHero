//
//  Example1ViewController.h
//  GitBrowser
//
//  Created by Peter Friese on 19.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Example1ViewController : UIViewController<RKRequestDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)forkYou:(id)sender;

@end
