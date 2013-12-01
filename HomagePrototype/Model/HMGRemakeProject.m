//
//  HMGRemakeProject.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGRemakeProject.h"
#import "HMGVideoSegment.h"
#import "HMGImageSegment.h"
#import "HMGTextSegment.h"
#import "HMGSegmentRemake.h"
#import "HMGVideoSegmentRemake.h"
#import "HMGImageSegmentRemake.h"
#import "HMGTextSegmentRemake.h"
#import "HMGAVUtils.h"
#import "HMGLog.h"
#import "HMGTake.h"
#import "HMGNetworkManager.h"

@implementation HMGRemakeProject

- (id)initWithTemplate:(HMGTemplate *) templateObj
{
    self = [super init];
    
    if (self)
    {
        self.templateObj = templateObj;
        NSMutableArray *segmentRemakes = [[NSMutableArray alloc] init];
        
        // Looping over the segments of the template in order to create the parallel segment remake objects
        for (HMGSegment *segment in self.templateObj.segments)
        {
            HMGSegmentRemake *segmentRemake = [self createSegmentRemakeFrom:segment];
            [segmentRemakes addObject:segmentRemake];
        }
        // Converting the NSMutable array into an NSArray
        self.segmentRemakes = [NSArray arrayWithArray:segmentRemakes];
    }
    return self;
}

// Creating a SegmentRemake object from a given Segment object
- (HMGSegmentRemake *)createSegmentRemakeFrom:(HMGSegment *)segment
{
    HMGSegmentRemake *segmentRemake;
    
    if ([segment isKindOfClass:[HMGVideoSegment class]])
    {
        segmentRemake = [[HMGVideoSegmentRemake alloc] init];
    }
    else if ([segment isKindOfClass:[HMGImageSegment class]])
    {
        segmentRemake = [[HMGImageSegmentRemake alloc] init];
    }
    else if ([segment isKindOfClass:[HMGTextSegment class]])
    {
        segmentRemake = [[HMGTextSegmentRemake alloc] init];
    }
    
    segmentRemake.segment = segment;
    
    return segmentRemake;
}

// This method will create/render the final video based on the selected take of each of its SegmentRemake objects. After the video is successfully created the completion handler will be called with the URL to the new video. If the there was a faliure in the video creation, videoURL in the completion handler will be nil, and an error will apear in the error object
- (void)renderVideoAsynchronouslyWithCompletionHandler:(void (^)(NSURL *videoURL, NSError *error))completion
{
    HMGLogInfo(@"%s started", __PRETTY_FUNCTION__);
    
    if (self.templateObj.templateFolder.length == 0)
    {
        NSMutableArray *videosToMerge = [[NSMutableArray alloc] init];
        
        // Looping over the project's segments to add thier videos to the videos to merge array
        for (HMGSegmentRemake *segmentRemake in self.segmentRemakes)
        {
            // Checking that there are takes in this segment
            if (segmentRemake.takes.count > 0)
            {
                // Assigning the segment's selected take
                HMGTake *segmentSelectedTake = segmentRemake.takes[segmentRemake.selectedTakeIndex];
                NSURL *segmentSelectedVideo = segmentSelectedTake.videoURL;
                [videosToMerge addObject:segmentSelectedVideo];
            }
            else
            {
                // throwing an exception that there is no video take in one of the segments
                [NSException raise:@"InvalidArgumentException" format:@"Segment <%@> has no video/takes. Cannot proceed with rendering the video", segmentRemake.segment.name];
            }
        }
        
        NSURL *soundtrack = self.templateObj.soundtrack;
        
        [HMGAVUtils mergeVideos:videosToMerge withSoundtrack:soundtrack completion:^(AVAssetExportSession *exporter) {
            completion(exporter.outputURL, exporter.error);
        }];
    }
    else
    {
        // Render on server
        NSURL *serverRender = [NSURL URLWithString:@"http://54.204.34.168:4567/render"];
        NSURLSession *session = [NSURLSession sharedSession];
        NSString *uniqueString = [[NSUUID UUID] UUIDString];
        NSString *fileOutputName = [NSString stringWithFormat:@"output-%@", uniqueString];
        NSDictionary *postParams = [NSDictionary dictionaryWithObjectsAndKeys:self.templateObj.templateProject, @"template_project", self.templateObj.templateFolder, @"template_folder", fileOutputName, @"output", nil];
        
        // Build POST request
        NSURLRequest *request = [HMGNetworkManager createPostRequestURL:serverRender withParams:postParams];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error)
            {
                HMGLogError(error.description);
                completion(nil, error);
            }
            else
            {
                HMGLogDebug(@"Render on server finished successfully");
                NSURL *downloadURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://54.204.34.168:4567/download/%@.mp4", fileOutputName]];
                completion(downloadURL, error);
            }
        }];
        
        [postDataTask resume];
    }
    
    HMGLogInfo(@"%s ended", __PRETTY_FUNCTION__);
}


@end
