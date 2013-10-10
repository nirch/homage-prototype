//
//  HMGImageSegmentRemake.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGImageSegmentRemake.h"
#import "HMGAVUtils.h"
#import "HMGSegment.h"
#import "HMGSegmentRemakeProtectedMethods.h"
#import "HMGLog.h"


@implementation HMGImageSegmentRemake


// This method will create a video based on the data in the current instance. The operation is asynchronous. After the video is successfully created, it will be saved as a new take and the completion handler will be called. If the there was a faliure in the video creation, videoURL in the completion handler will be nil, and an error will apear in the error object.
- (void)processVideoAsynchronouslyWithCompletionHandler:(void (^)(NSURL *videoURL, NSError *error))completion
{
    HMGLogDebug(@"%s started", __PRETTY_FUNCTION__);
    
    // If there is no video assiged in this instance we cannot proceed
    if (self.images.count == 0)
    {
        [NSException raise:@"InvalidArgumentException" format:@"self.images must contain at least 1 image"];
    }
    
    // Calculating the time per image/frame. This is the total duraion of the segment divided by the number of images
    CMTime totalDuration = self.segment.duration;
    CMTimeValue valuePerFrame = totalDuration.value / self.images.count;
    CMTime frameTime = CMTimeMake(valuePerFrame, totalDuration.timescale);
    
    // Creating a video from the set o images (async)
    [HMGAVUtils imagesToVideo:self.images withFrameTime:frameTime completion:^(AVAssetWriter *assetWriter) {
        [self processVideoDidFinishWithWriter:assetWriter withCompletion:completion];
    }];
    
    HMGLogDebug(@"%s ended", __PRETTY_FUNCTION__);
}

- (NSArray *)images
{
    if(!_images) _images = [[NSArray alloc] init];
    return _images;
}


@end
