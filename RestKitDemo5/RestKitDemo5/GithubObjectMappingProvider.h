//
//  GithubObjectMappingProvider.h
//  RestKitDemo4
//
//  Created by Peter Friese on 27.06.12.
//  Copyright (c) 2012 Peter Friese. All rights reserved.
//

#import "RKObjectMappingProvider.h"

@interface GithubObjectMappingProvider : RKObjectMappingProvider

+ (id)mappingProviderWithObjectStore:(RKManagedObjectStore *)objectStore;

@property (nonatomic, strong) RKManagedObjectStore *objectStore;

@end
