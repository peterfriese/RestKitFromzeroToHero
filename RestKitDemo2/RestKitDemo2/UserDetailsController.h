//
//  UserDetialsController.h
//  GitBrowser
//
//  Created by Peter Friese on 20.03.12.
//  Copyright (c) 2012 peterfriese.de. All rights reserved.
//

@interface UserDetailsController : QuickDialogController<RKObjectLoaderDelegate>

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *protocol;

@end
