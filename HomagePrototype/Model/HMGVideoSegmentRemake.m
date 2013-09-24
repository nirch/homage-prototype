//
//  HMGVideoSegmentRemake.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGVideoSegmentRemake.h"
#define PVIDEO_FILE @"processedVideo.mov"

@implementation HMGVideoSegmentRemake

- (void) assignVideo:(NSURL *) recordedVideoURL
{
    [self.takes addObject:([self createVideo:recordedVideoURL])];
    //Currently the Raw video is deleted but it should be later saved and stored somehow for analysis
    [self deleteVideoAtURL:recordedVideoURL];
    //if this is the first take then assign the selectedIndex to be the first item
    if(self.takes.count ==1)self.selectedTakeIndex =0;
}
-(NSURL *)createVideo:(NSURL *)inputVideo
{
    return [self copyVideoToNewURL:inputVideo];
}

//TBD - Extract this Method to a Video Utils class since it is duplicated from the Recorder Controller
//Also this should be a dynamic name with a GUID since there might be a few "live" url's
- (NSURL *)outputURL {
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:PVIDEO_FILE];
	return [NSURL fileURLWithPath:filePath];
}
//TBD - extract this Methos to Video Utils class
-(void)deleteVideoAtURL:(NSURL *) videoURL
{
    [[NSFileManager defaultManager] removeItemAtURL:videoURL error:nil];
}
//TBD - this Method also does not need to be here - move it to Video/file manager Utills

-(NSURL *)copyVideoToNewURL:(NSURL *) videoURL
{
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSURL * newVideoURL = [self outputURL];
    [manager copyItemAtURL:videoURL toURL:newVideoURL error:nil];
    return newVideoURL;
}
@end
