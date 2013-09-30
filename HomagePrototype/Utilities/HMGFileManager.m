//
//  HMGFileManager.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGFileManager.h"

@implementation HMGFileManager

- (NSURL *)outputURL:(NSString *)fileName
{
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
	NSUUID  *UUID = [NSUUID UUID];
    NSString *NewFileName = [[UUID UUIDString] stringByAppendingString:fileName];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:NewFileName];
	return [NSURL fileURLWithPath:filePath];
}
-(NSURL *)copyVideoToNewURL:(NSURL *) videoURL forFileName:(NSString *)fileName
{
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSURL * newVideoURL =[self outputURL:fileName];
    [manager copyItemAtURL:videoURL toURL:newVideoURL error:nil];
    return newVideoURL;
}
@end
