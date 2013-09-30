//
//  HMGVideoSegmentRemake.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGVideoSegmentRemake.h"
#import "HMGFileManager.h"


#define PVIDEO_FILE_PREFIX @"processedVideo"
#define PVIDEO_FILE_TYPE @"mov"

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
    return [HMGFileManager copyResourceToNewURL:inputVideo forFileName:PVIDEO_FILE_PREFIX ofType:PVIDEO_FILE_TYPE];
}

//TBD - extract this Method to Video Utils class
-(void)deleteVideoAtURL:(NSURL *) videoURL
{
    [[NSFileManager defaultManager] removeItemAtURL:videoURL error:nil];
}
@end
