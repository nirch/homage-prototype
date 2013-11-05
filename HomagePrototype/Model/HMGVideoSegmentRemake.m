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
#import "HMGLog.h"


#define PVIDEO_FILE_PREFIX @"videoSegmentProcessedVideo-"
#define PVIDEO_FILE_TYPE @"mov"

@implementation HMGVideoSegmentRemake


// This method will create a video based on the data in the current instance. The operation is asynchronous. After the video is successfully created, it will be saved as a new take and the completion handler will be called. If the there was a faliure in the video creation, videoURL in the completion handler will be nil, and an error will apear in the error object.
- (void)processVideoAsynchronouslyWithCompletionHandler:(void (^)(NSURL *videoURL, NSError *error))completion
{
    HMGLogDebug(@"%s started", __PRETTY_FUNCTION__);
    
    // If there is no video assiged in this instance we cannot proceed
    if (!self.video)
    {
        [NSException raise:@"InvalidArgumentException" format:@"self.video must not be null"];
    }
    
    // TODO: check that self.video is a URL to a video
    
    HMGVideoSegment *videoSegment = (HMGVideoSegment *)self.segment;
    CMTime playDuration = videoSegment.duration;
    
    // TODO: (1) Do we need to check that the actual duration equals the recordDuration? What if it is not? (2) What about soundtrack?

    // Scaling the raw video to the "play" duration
    [HMGAVUtils scaleVideo:self.video toDuration:playDuration completion:^(AVAssetExportSession *exporter) {
        [self processVideoDidFinish:exporter withCompletion:completion];
    }];
    
    
    // The following code creates a copy of the raw video, it will be needed once we will need the soundtrack (maybe a different SegmentRemake object?)
    /*
        // Dispatching an async block that will copy the video to a new location, adds the copied video to the takes and finally calles the completion handler
        //dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *copiedVideoURL = [HMGFileManager copyResourceToNewURL:self.video forFileName:PVIDEO_FILE_PREFIX ofType:PVIDEO_FILE_TYPE];
            [self addVideoTake:copiedVideoURL];
            completion(copiedVideoURL, nil);
        });
     */
    
    HMGLogDebug(@"%s ended", __PRETTY_FUNCTION__);
}



@end
