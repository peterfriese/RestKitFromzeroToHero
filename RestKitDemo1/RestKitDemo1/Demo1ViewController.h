//
//  Demo1ViewController.h
//  RestKitDemo1
//
//  Created by Peter Friese on 25.06.12.
//  Copyright (c) 2012 Peter Friese. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Demo1ViewController : UIViewController<RKRequestDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)forkYouRegular;
- (IBAction)forkYouWithBlocks;

@end
