//
//  AppDelegate.h
//  RestKitDemo4
//
//  Created by Peter Friese on 26.06.12.
//  Copyright (c) 2012 Peter Friese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, LoginHandlerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
