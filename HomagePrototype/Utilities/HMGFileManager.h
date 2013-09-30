//
//  HMGFileManager.h
//  HomagePrototype
//
//  Created by Tomer Harry on 9/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMGFileManager : NSObject

// Creates a unique URL in the documents librarys based on a given name (the given name is appended to the full path)
+ (NSURL *)uniqueURL:(NSString *)fileName;

// Copies a given resource to a new location
+ (NSURL *)copyResourceToNewURL:(NSURL *) resourceURL forFileName:(NSString *)fileName;

// Removes (deletes) a resource from a given URL
+ (BOOL)removeResourceAtURL:(NSURL *)resourceURL error:(NSError **)error;

@end
