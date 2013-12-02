//
//  HMGFileManager.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGFileManager.h"
#import "HMGLog.h"

@implementation HMGFileManager

// Creates a unique URL in the documents library with a given prefix (prefix is optional)
+ (NSURL *)uniqueUrlWithPrefix:(NSString *)fileNamePrefix ofType:(NSString *)fileType;
{
    if(fileType==nil)HMGLogWarning(@"%s fileType is nill - a file without extention will be created", __PRETTY_FUNCTION__);
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
//TODO: remove Duplicate function
+ (NSString *)generatePath:(NSString *)fileNamePrefix ofType:(NSString *)fileType;
{
    if(fileType==nil)HMGLogWarning(@"%s fileType is nill - a file without extention will be created", __PRETTY_FUNCTION__);
    // Getting the path to the documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName;
    if (fileType)
    {
        fileName = [[fileNamePrefix stringByAppendingString:@"."] stringByAppendingString:fileType];
    }
    
    NSString *fullFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    return fullFilePath;
    //return [NSURL fileURLWithPath:fullFilePath];
    
}

+ (BOOL)fileExistsAtPath:(NSString *)filePath;
{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"documents path is: %@",documentsPath);
    NSString* foofile = [documentsPath stringByAppendingPathComponent:@"data.plist"];
    NSLog(@"full path is %@" , foofile);
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    if (fileExists) {
        NSLog(@"file exists!");
    }
    
    //NSString *filePathAsString = [filePath absoluteString];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        return YES;
    } else {
        return NO;
    }
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
    HMGLogDebug(@"%s resourceURL = %@", __PRETTY_FUNCTION__, resourceURL.description);
    
    return [[NSFileManager defaultManager] removeItemAtURL:resourceURL error:error];
}


@end
