//
//  HMGVideoSegmentRemake.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGVideoSegmentRemake.h"
#import "HMGSegmentRemakeProtectedMethods.h"
#import "HMGVideoSegment.h"
#import "HMGFileManager.h"
#import "HMGAVUtils.h"


#define PVIDEO_FILE_PREFIX @"videoSegmentProcessedVideo"
#define PVIDEO_FILE_TYPE @"mov"

@implementation HMGVideoSegmentRemake


// This method will create a video based on the data in the current instance. The operation is asynchronous. After the video is successfully created, it will be saved as a new take and the completion handler will be called. If the there was a faliure in the video creation, videoURL in the completion handler will be nil, and an error will apear in the error object.
- (void)processVideoAsynchronouslyWithCompletionHandler:(void (^)(NSURL *videoURL, NSError *error))completion
{
    // If there is no video assiged in this instance we cannot proceed
    if (!self.video)
    {
        [NSException raise:@"InvalidArgumentException" format:@"self.video must not be null"];
    }
    
    // TODO: check that self.video is a URL to a video
    
    HMGVideoSegment *videoSegment = (HMGVideoSegment *)self.segment;
    CMTime playDuration = videoSegment.duration;
    CMTime recordDuration = videoSegment.recordDuration;
    
    // If the play duration and the record duration are not equal we need to scale the video. Otherwise we will just create a copy of the input video
    if (CMTIME_COMPARE_INLINE(playDuration, !=, recordDuration))
    {
        [HMGAVUtils scaleVideo:self.video toDuration:playDuration completion:^(AVAssetExportSession *exporter) {
            [self processVideoDidFinish:exporter withCompletion:completion];
        }];
    }
    else
    {
        // Dispatching an async block that will copy the video to a new location, adds the copied video to the takes and finally calles the completion handler
        //dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *copiedVideoURL = [HMGFileManager copyResourceToNewURL:self.video forFileName:PVIDEO_FILE_PREFIX ofType:PVIDEO_FILE_TYPE];
            [self addVideoTake:copiedVideoURL];
            completion(copiedVideoURL, nil);
        });
    }

}


/*
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
    HMGVideoSegment *videoSegment = (HMGVideoSegment *)self.segment;
    CMTime playDuration = videoSegment.duration;
    CMTime recordDuration = videoSegment.recordDuration;
    
    // If the play duration and the record duration are not equal we need to scale the video. Otherwise we will just create a copy of the input video
    if (CMTIME_COMPARE_INLINE(playDuration, ==, recordDuration))
    {
        [HMGAVUtils scaleVideo:inputVideo toDuration:playDuration completion:^(AVAssetExportSession *exporter) {
            ///
        }];
    }
    
    
    return [HMGFileManager copyResourceToNewURL:inputVideo forFileName:PVIDEO_FILE_PREFIX ofType:PVIDEO_FILE_TYPE];
}

//TBD - extract this Method to Video Utils class
-(void)deleteVideoAtURL:(NSURL *) videoURL
{
    [[NSFileManager defaultManager] removeItemAtURL:videoURL error:nil];
}
 */
@end
