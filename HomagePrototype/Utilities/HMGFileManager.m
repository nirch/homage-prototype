//
//  HMGFileManager.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGFileManager.h"

@implementation HMGFileManager

// Creates a unique URL in the documents library with a given prefix (prefix is optional)
+ (NSURL *)uniqueUrlWithPrefix:(NSString *)fileNamePrefix ofType:(NSString *)fileType;
{
    // Getting the path to the documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSUUID *uniqueID = [NSUUID UUID];
    
    NSString *fileName;
    if (fileNamePrefix)
    {
        fileName = [fileNamePrefix stringByAppendingString:[uniqueID UUIDString]];
    }
    else
    {
        fileName = [uniqueID UUIDString];
    }
    
    if (fileType)
    {
        fileName = [[fileName stringByAppendingString:@"."] stringByAppendingString:fileType];
    }
    
    NSString *fullFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    return [NSURL fileURLWithPath:fullFilePath];
}


// Copies a given resource to a new location
+ (NSURL *)copyResourceToNewURL:(NSURL *)resourceURL forFileName:(NSString *)fileNamePrefix ofType:(NSString *)fileType;
{
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSURL * newVideoURL =[self uniqueUrlWithPrefix:fileNamePrefix ofType:fileType];
    [manager copyItemAtURL:resourceURL toURL:newVideoURL error:nil];
    return newVideoURL;
}

// Removes (deletes) a resource from a given URL
+ (BOOL)removeResourceAtURL:(NSURL *)resourceURL error:(NSError **)error;
{
    return [[NSFileManager defaultManager] removeItemAtURL:resourceURL error:error];
}


@end
