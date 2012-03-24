//
//  LoginInfo.h
//  GitBrowser
//
//  Created by Peter Friese on 23.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginInfo : NSObject {

@private
    NSString *_password;
    NSString *_login;
}

@property(strong) NSString *login;
@property(strong) NSString *password;

@end